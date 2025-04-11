import 'dart:developer';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_cupertino_fields/form_builder_cupertino_fields.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/features/capture/service/pose_landmarks.dart';
import 'package:visualpt/models/ModelProvider.dart';

class MCTSIB implements BaseAssessment {
  @override
  AssessmentType get type => AssessmentType.MCTSIB;

  @override
  String get name => "Modified Clinical Test of Sensory Integration & Balance";

  @override
  String get normalDuration => "5 minutes";

  @override
  get details =>
      """Modified Clinical Test of Sensory Integration & Balance is a test used to assess the sensory integration of balance. \n\nThe test is used to identify the sensory system that is contributing to balance deficits.\n\nThe test is performed in a quiet environment with the profile standing on a firm surface with eyes open, eyes closed.\n\nThe test is then repeated with the profile standing on a foam surface. It is considered modified since it does not test the visual conflict dome stages""";

  @override
  String get imagePath => ""; //TODO

  @override
  String get stageGifPath => ""; //TODO

  @override
  int get stages => 4;

  @override
  int get trials => 1;

  @override
  int get trialDuration => 30;

  @override
  List<String> get stageNames => [
        "Eyes Open, Firm Surface",
        "Eyes Closed, Firm Surface",
        "Eyes Open, Foam Surface",
        "Eyes Closed, Foam Surface",
      ];

  List<String> get surface => [
        "Firm",
        "Firm",
        "Foam",
        "Foam",
      ];

  List<String> get vision => [
        "Eyes Open",
        "Eyes Closed",
        "Eyes Open",
        "Eyes Closed",
      ];

  @override
  List<List<String>> get stageInstructions => List.filled(stages, [
        "Hold the camera steady and level",
        "Only one person should be in the frame at a time",
      ]);

  @override
  List<bool> get stageObtrusion => [false, false, true, true];

  @override
  List<bool> get stageInstability => List.filled(4, false);

  @override
  Map<String, FormFieldItem> get formFields => {
        "fall history": FormFieldItem(
          form: FormBuilderCupertinoSegmentedControl(
            name: "fall history",
            helper: const Text("Fall History", style: Styles.prefixStyle),
            options: FallHistory.values
                .map((e) =>
                    FormBuilderFieldOption(value: e, child: Text(e.name)))
                .toList(),
          ),
          value: "NONE",
        )
      };

  @override
  bool get isTrainingData => true;

  @override
  bool get isAvailable => true;

  static const norms = [179.7, 180.0, 179.9, 177.7];
  static const ageGroups = [20, 49, 59, 69, 79];

  static double getAgeNorm(int age) {
    final int index = ageGroups.indexWhere((element) => element > age);
    return norms[index];
  }

  @override
  Future<List<Norm>?> getNorms(TemporalDate dob, Gender gender) async {
    try {
      final AgeRange ageRange = getAgeEnumByTemporalDate(dob);
      final request = ModelQueries.list(Norm.classType,
          where: Norm.TYPE
              .eq(AssessmentType.CTSIB)
              .and(Norm.AGERANGE.eq(ageRange).and(Norm.GENDER.eq(gender))));
      final response = await Amplify.API.query(request: request).response;

      final norms = response.data?.items;
      if (norms == null || norms.isEmpty) {
        return null;
      } else {
        return norms.map((e) => e as Norm).toList();
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<Norm?> setNorm(TemporalDate dob, Gender gender, int seqNum,
      double score, int trials) async {
    try {
      final existingNorms = await getNorms(dob, gender);
      final existingNorm =
          existingNorms?.firstWhere((element) => element.stageNumber == seqNum);

      if (existingNorm != null) {
        final request = ModelMutations.update(existingNorm.copyWith(
          scoreSum: existingNorm.scoreSum + score,
          trialSum: existingNorm.trialSum + trials,
        ));
        final response = await Amplify.API.mutate(request: request).response;
        return response.data;
      } else {
        final newNorm = Norm(
          type: AssessmentType.CTSIB,
          ageRange: getAgeEnumByTemporalDate(dob),
          gender: gender,
          stageNumber: seqNum,
          scoreSum: score,
          trialSum: trials,
          createdAt: TemporalDateTime.now(),
          updatedAt: TemporalDateTime.now(),
        );
        final request = ModelMutations.create(newNorm);
        final response = await Amplify.API.mutate(request: request).response;
        return response.data;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  List<List<double>> calculateScores(Assessment assessment) {
    final validStages = assessment.stages
            ?.where((stage) => stage.trials != null && stage.trials!.isNotEmpty)
            .toList() ??
        [];

    try {
      final conditionScores = validStages.map((stage) {
        return stage.trials!.map((trial) {
          final detections =
              PoseLandmarks.decodeCompressed(trial.compressedDetections);
          if (detections.isEmpty) {
            return 0.0;
          }
          final detectionCountAndScoreSum = detections.fold<(int, double)>(
              (0, 0.0), (detectionCountAndScore, detection) {
            if (detectionCountAndScore.$1 != 0 &&
                detectionCountAndScore.$2 == 0) {
              return detectionCountAndScore;
            }
            final (isFall, detectionScore) = CTSIB.poseToCtsibData(detection);

            if (isFall) {
              return (detectionCountAndScore.$1 + 1, 0.0);
            } else {
              return (
                detectionCountAndScore.$1 + 1,
                detectionCountAndScore.$2 + detectionScore
              );
            }
          });
          final trialScore =
              detectionCountAndScoreSum.$2 / detectionCountAndScoreSum.$1;

          return trialScore.isNaN ? 0.0 : trialScore;
        }).toList();
      }).toList();
      return conditionScores;
    } on Exception catch (e) {
      log(e.toString());
      return List.generate(validStages.length, (_) => [0.0], growable: false);
    }
  }

  @override
  String getNormativeMessage(Assessment assessment, List<Norm>? norms) {
    final globalScores = norms
            ?.map((s) => s.trialSum == 0 ? 0 : s.scoreSum / s.trialSum)
            .reduce((a, b) => (a) + (b)) ??
        0.0;
    final localScores = assessment.stages
            ?.map((s) => s.trials?.fold(0.0,
                (previousValue, element) => previousValue + element.duration))
            .reduce((a, b) => (a ?? 0.0) + (b ?? 0.0)) ??
        0.0;
    final percent = ((localScores - globalScores) / globalScores) * 100;

    return "Patients total score is $localScores. The global norm is $globalScores, which is ${percent.abs()}% of age gender norms";
  }

  @override
  bool isComplete(Detection? detection) {
    if (detection == null) {
      return true; // Person MUST be detected during the full assessment for it to be complete
    }
    final (isFall, __) = CTSIB.poseToCtsibData(detection);
    return isFall;
  }
}
