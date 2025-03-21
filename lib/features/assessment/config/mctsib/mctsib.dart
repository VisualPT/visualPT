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
  List<String> get conditionNames => [
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
  List<List<String>> get conditionInstructions => List.filled(stages, [
        "Hold the camera steady and level",
        "Only one person should be in the frame at a time",
      ]);

  @override
  List<bool> get conditionObtrusion => [false, false, true, true];

  @override
  List<bool> get conditionInstability => List.filled(4, false);

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

  static List<List<int>> getPredictionTotals(Assessment assessment) {
    // Filter out null stages and stages without trials
    final validStages = assessment.stages
            ?.where((stage) => stage.trials != null && stage.trials!.isNotEmpty)
            .toList() ??
        [];

    return validStages.map((stage) {
      // Initialize the list for counting predictions
      final totalPredictions = List<int>.filled(5, 0);

      // Iterate over each trial
      for (int i = 0; i < stage.trials!.length; i++) {
        final trial = stage.trials![i];
        final keypoints =
            PoseLandmarks.decodeCompressed(trial.compressedKeypoints);
        if (keypoints.isNotEmpty) {
          // Iterate over each detection
          for (int j = 0; j < keypoints.length; j++) {
            final detection = keypoints[j];
            final prediction = int.tryParse(detection.prediction ?? "-1");
            if (prediction != null &&
                prediction >= 0 &&
                prediction < totalPredictions.length) {
              totalPredictions[prediction]++;
            }
          }
        }
      }
      return totalPredictions;
    }).toList();
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
  List<double> calculateScores(Assessment assessment) {
    //Equilibrium Score is the the proportion of the actual sway to the swayLimit, multiplied by 100, summed up and divided by the number of detections per trial, then summed across all trials and divided by the number of trials
    final validStages = assessment.stages
            ?.where((stage) => stage.trials != null && stage.trials!.isNotEmpty)
            .toList() ??
        [];

    try {
      final conditionScores = validStages.map((stage) {
        final trialsCountAndScoreSum = stage.trials!.fold<(int, double)>(
            (0, 0.0), (trialsCountAndScoreIterator, trial) {
          final keypoints =
              PoseLandmarks.decodeCompressed(trial.compressedKeypoints);

          if (keypoints.isEmpty) {
            return trialsCountAndScoreIterator;
          }
          final detectionCountAndScoreSum = keypoints.fold<(int, double)>(
              (0, 0.0), (detectionCountAndScoreIterator, detection) {
            final (xSway, _) = PoseLandmarks.computeAngles(detection);
            final latProportion = xSway / swayLimits[2];
            //If the profile is leaning forward, the angle will be negative, so use the anterior sway limit
            // final lonProportion =
            //     zSway > 0 ? zSway / swayLimits[0] : zSway / swayLimits[1];
            //TODO: since the zSway is not to scale, the lonProportion will usually be greater than 1, usually leading to an equilibrium score of 0.
            // A new pose detection model should be trained to fix this
            if (latProportion > 1 /* || lonProportion > 1*/) {
              return (
                detectionCountAndScoreIterator.$1 + 1,
                detectionCountAndScoreIterator.$2,
              );
            }
            final proportionOfFailure = latProportion;
            //sqrt(pow(latProportion, 2) + pow(lonProportion, 2));
            final detectionScore = 100 * (1 - proportionOfFailure);
            return (
              detectionCountAndScoreIterator.$1 + 1,
              detectionCountAndScoreIterator.$2 + detectionScore
            );
          });
          final trialScore =
              detectionCountAndScoreSum.$2 / detectionCountAndScoreSum.$1;

          return (
            trialsCountAndScoreIterator.$1 + 1,
            trialsCountAndScoreIterator.$2 + trialScore
          );
        });
        final value = trialsCountAndScoreSum.$2 / trialsCountAndScoreSum.$1;
        return value.isNaN ? 0.0 : value;
      }).toList();
      return conditionScores;
    } on Exception catch (e) {
      print(e);
      return List.generate(validStages.length, (index) => 0.0, growable: false);
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
