import 'dart:math';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:form_builder_cupertino_fields/form_builder_cupertino_fields.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/features/capture/service/pose_landmarks.dart';

import 'package:visualpt/models/ModelProvider.dart';

class CTSIB implements BaseAssessment {
  @override
  AssessmentType get type => AssessmentType.CTSIB;

  @override
  String get name => "Clinical Test of Sensory Integration & Balance";

  @override
  String get normalDuration => "5 minutes";

  @override
  get details =>
      """Clinical Test of Sensory Integration & Balance is a test used to assess the sensory integration of balance. \n\nThe test is used to identify the sensory system that is contributing to balance deficits.\n\nThe test is performed in a quiet environment with the profile standing on a firm surface with eyes open, eyes closed, and with a visual conflict dome.\n\nThe test is then repeated with the profile standing on a foam surface.""";

  @override
  String get imagePath => "assets/images/ctsib_mainlogo.png";

  @override
  String get stageGifPath => "assets/videos/CTSIB/CTSIB";

  @override
  int get stages => 6;

  @override
  int get trials => 1;

  @override
  int get trialDuration => 30; //TODO: Make this dynamic

  @override
  List<String> get stageNames => [
        "Eyes Open, Firm Surface",
        "Eyes Closed, Firm Surface",
        "Visual Conflict Dome, Firm Surface",
        "Eyes Open, Foam Surface",
        "Eyes Closed, Foam Surface",
        "Visual Conflict Dome, Foam Surface",
      ];

  List<String> get surface => [
        "Firm",
        "Firm",
        "Firm",
        "Foam",
        "Foam",
        "Foam",
      ];

  List<String> get vision => [
        "Eyes Open",
        "Eyes Closed",
        "Conflict Dome",
        "Eyes Open",
        "Eyes Closed",
        "Conflict Dome",
      ];

  @override
  List<List<String>> get stageInstructions => List.filled(stages, [
        "Hold the camera steady and level",
        "Only one person should be in the frame at a time",
      ]);

  @override
  List<bool> get stageObtrusion => [false, false, false, true, true, true];

  @override
  List<bool> get stageInstability => [false, false, true, false, false, true];

  @override
  Map<String, FormFieldItem> get formFields => {
        "head motions": FormFieldItem<bool>(
          form: FormBuilderCupertinoSwitch(
              key: const Key("head_motions"),
              name: "Head Motions",
              prefix: const Text("Head Motions", style: Styles.prefixStyle),
              initialValue: false),
          value: false,
        ),
        "trial count": FormFieldItem(
          form: FormBuilderCupertinoSegmentedControl(
            key: const Key("trial_count"),
            name: "Trial Count",
            prefix: const Text("Trial Count", style: Styles.prefixStyle),
            initialValue: 1,
            shouldExpandedField: true,
            options: [1, 2, 3]
                .map((e) => FormBuilderFieldOption(
                      value: e,
                      child: Text(
                        e.toString(),
                        style: Styles.inputStyle,
                        softWrap: false,
                      ),
                    ))
                .toList(),
          ),
          value: 1,
        ),
        "trial duration": FormFieldItem<int>(
          form: FormBuilderCupertinoSegmentedControl<int>(
            key: const Key("trial_duration"),
            name: "Trial Duration",
            prefix: const Text("Trial Duration", style: Styles.prefixStyle),
            shouldExpandedField: true,
            options: [10, 15, 20, 30]
                .map((e) => FormBuilderFieldOption(
                      value: e,
                      child: Text(
                        e.toString(),
                        style: Styles.inputStyle,
                        softWrap: false,
                      ),
                    ))
                .toList(),
          ),
          value: 30,
        ),
        "fall history": FormFieldItem<FallHistory>(
          //TODO: Build a FormBuilder Cupertino Dialog selection for this
          form: FormBuilderCupertinoSegmentedControl(
              key: const Key("fall_history"),
              name: "Fall History",
              helper: const Text("Fall History", style: Styles.prefixStyle),
              shouldExpandedField: true,
              options: FallHistory.values
                  .map((e) => FormBuilderFieldOption(
                      value: e,
                      child: Text(
                        e.name,
                        style: Styles.inputStyle,
                        softWrap: false,
                      )))
                  .toList(),
              valueTransformer: (value) {
                if (value == null) {
                  return FallHistory.NONE;
                } else {
                  return value;
                }
              }),
          value: FallHistory.NONE,
        ),
        if (kDebugMode)
          "store data": FormFieldItem<bool>(
            form: FormBuilderCupertinoSwitch(
                key: const Key("store_data"),
                name: "Store Data",
                prefix: const Text("Store Data", style: Styles.prefixStyle),
                initialValue: true),
            value: true,
          ),
      };

  @override
  bool get isTrainingData => true;

  @override
  bool get isAvailable => true;

  @override
  Future<List<Norm>?> getNorms(TemporalDate dob, Gender gender) async {
    try {
      final AgeRange ageRange = getAgeEnumByTemporalDate(dob);

      //Temporary solution till the DB is populated
      final norm = createNormData()
          .where((element) =>
              element.ageRange == ageRange && element.gender == gender)
          .toList()
        ..sort((a, b) => a.stageNumber.compareTo(b.stageNumber));
      return norm;
      //Temporary solution till the DB is populated

      final request = ModelQueries.list(Norm.classType,
          where: Norm.TYPE
              .eq(AssessmentType.CTSIB)
              .and(Norm.AGERANGE.eq(ageRange).and(Norm.GENDER.eq(gender))));
      final response = await Amplify.API.query(request: request).response;

      final norms = response.data?.items;
      if (norms == null || norms.isEmpty) {
        return [];
      } else {
        return norms.map((e) => e as Norm).toList();
      }
    } catch (e) {
      print(e);
      return [];
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
    //If the sway detected is greater than the sway limit, the score is 0
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
              (0, 0.0), (detectionCountAndScore, detection) {
            //If a fall has been registered, in other words, a detection registered and the score 0
            if (detectionCountAndScore.$1 != 0 &&
                detectionCountAndScore.$2 == 0) {
              //The score remains 0
              return detectionCountAndScore;
            }
            final (isFall, detectionScore) = poseToCtsibData(detection);

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
    // Do not include the last value in the score list as it is the total score
    final globalScores = norms
            ?.map((s) => s.trialSum == 0 || s.stageNumber == stages
                ? 0
                : s.scoreSum / s.trialSum)
            .reduce((a, b) => (a) + (b)) ??
        0.0;

    // Calculate local scores for the patient
    final localScores = calculateScores(assessment).reduce((a, b) => a + b);

    // Calculate the percentage difference between patient and norm
    final percent = ((localScores - globalScores) / globalScores) * 100;

    // Generate a clinically relevant message
    String performanceComparison;
    if (localScores > globalScores) {
      performanceComparison =
          "${percent.abs().toStringAsFixed(2)}% higher than the normative data.";
    } else {
      performanceComparison =
          "${percent.abs().toStringAsFixed(2)}% lower than the normative data.";
    }

    String riskMessage;
    if (percent < -20) {
      riskMessage =
          "This score indicates a significantly increased risk for falls compared to age and gender norms.";
    } else if (percent < 0) {
      riskMessage =
          "This performance is below norms but within an acceptable range, though caution is advised.";
    } else {
      riskMessage = "This is a healthy performance within the normative range.";
    }

    return "This patient's performance is $performanceComparison $riskMessage";
  }

  @override
  bool isComplete(Detection? detection) {
    if (detection == null) {
      return true; // Person MUST be detected during the full assessment for it to be complete
    }
    final (isFall, __) = CTSIB.poseToCtsibData(detection);
    return isFall;
  }

  //Numbers are in m/s and start in the 6-12, then 13-19, then 20-29, 30-39... to 80+
  // static const norms = [179.7, 180.0, 179.9, 177.7];
  // static const ageGroups = [20, 49, 59, 69, 79];

  static List<(double, double)> averageSwayPerCondition(Assessment assessment) {
    // Filter out null stages and stages without trials
    final validStages = assessment.stages
            ?.where((stage) => stage.trials != null && stage.trials!.isNotEmpty)
            .toList() ??
        [];

    return validStages.map((stage) {
      // CalculaStagesway and count of detections
      final totalAndCount = stage.trials!.fold<(int, (double, double))>(
          (0, (0.0, 0.0)), (previousValue, trial) {
        final keypoints =
            PoseLandmarks.decodeCompressed(trial.compressedKeypoints);
        if (keypoints.isEmpty) {
          return previousValue;
        }
        final trialTotalAndCount = keypoints.fold<(int, (double, double))>(
            (0, (0.0, 0.0)), (averageAngle, detection) {
          final angle = PoseLandmarks.computeAngles(detection);

          return (
            averageAngle.$1 + 1,
            (averageAngle.$2.$1 + angle.$1, averageAngle.$2.$2 + angle.$2)
          );
        });
        return (
          previousValue.$1 + trialTotalAndCount.$1,
          (
            previousValue.$2.$1 + trialTotalAndCount.$2.$1,
            previousValue.$2.$2 + trialTotalAndCount.$2.$2
          )
        );
      });

      if (totalAndCount.$1 == 0) {
        return (0.0, 0.0);
      }
      // Calculate and return the average sway for this stage
      return (
        totalAndCount.$2.$1 / totalAndCount.$1,
        totalAndCount.$2.$2 / totalAndCount.$1
      );
    }).toList();
  }

  static List<(double, double)> maxSwayPerCondition(Assessment assessment) {
    // Filter out null stages and stages without trials
    final validStages = assessment.stages
            ?.where((stage) => stage.trials != null && stage.trials!.isNotEmpty)
            .toList() ??
        [];

    return validStages.map((stage) {
      // CalculaStagesway anstagef detections
      final maxSway = stage.trials!.fold<(double, double)>((0.0, 0.0),
          (previousValue, trial) {
        final keypoints =
            PoseLandmarks.decodeCompressed(trial.compressedKeypoints);
        if (keypoints.isEmpty) {
          return previousValue;
        }
        final trialMaxSway =
            keypoints.fold<(double, double)>((0.0, 0.0), (maxAngle, detection) {
          final (lat, lng) = PoseLandmarks.computeAngles(detection);

          return (max(maxAngle.$1, lat), max(maxAngle.$2, lng));
        });

        return (
          max(previousValue.$1, trialMaxSway.$1),
          max(previousValue.$2, trialMaxSway.$2)
        );
      });

      return maxSway;
    }).toList();
  }

  static List<List<int>> getPredictionTotals(Assessment assessment) {
    // Filter out null stages and stages without trials
    final validStages = assessment.stages
            ?.where((stage) => stage.trials != null && stage.trials!.isNotEmpty)
            .toList() ??
        [];

    return validStages.map((stage) {
      // InitialStagesst for counting predictions
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

  //Returns isFall, equlibrium score
  static (bool, double) poseToCtsibData(Detection detection) {
    final (xSway, zSway) = PoseLandmarks.computeAngles(detection);
    final latProportion = xSway / swayLimits[2];
    final lonProportion =
        zSway > 0 ? zSway / swayLimits[0] : zSway / swayLimits[1];

    if (latProportion > 1 || lonProportion > 1) {
      //This indicates a fall
      return (true, 0.0);
    }
    final proportionOfFailure =
        sqrt(pow(latProportion, 2) + pow(lonProportion, 2));
    final detectionScore = 100 * (1 - proportionOfFailure);
    return (
      false, //No fall
      detectionScore,
    );
  }
}

//Anterior, Posterior, Lat
const swayLimits = [8.0, 4.5, 8.0];

Map<AgeRange, List<double>> normativeValues = {
  AgeRange.BABY_0_5: [86.1, 83.4, 81.6, 86.1, 82.8, 82.1, 83.7],
  AgeRange.CHILD_6_12: [86.1, 83.4, 81.6, 86.1, 82.8, 82.1, 83.7],
  AgeRange.TEEN_13_19: [86.1, 83.4, 81.6, 86.1, 82.8, 82.1, 83.7],
  AgeRange.ADULT_20_39: [86.1, 83.4, 81.6, 86.1, 82.8, 82.1, 83.7],
  AgeRange.ADULT_40_64: [87.9, 85.3, 87.5, 83.4, 81.5, 78.9, 84.1],
  AgeRange.SENIOR_65_69: [88.7, 85.5, 87.9, 80.4, 71.6, 65.5, 78.3],
  AgeRange.SENIOR_70_79: [89.4, 85.8, 88.2, 77.6, 61.6, 53.0, 72.8],
  AgeRange.SENIOR_80_84: [94.3, 91.1, 90.0, 77.2, 48.8, 47.7, 69.9],
  AgeRange.SENIOR_85_PLUS: [92.6, 89.9, 89.9, 71.2, 28.9, 33.2, 60.7],
};

List<Norm> createNormData() {
  List<Norm> norms = [];

  // AssessmentType for this data
  AssessmentType assessmentType = AssessmentType.CTSIB;

  // Create norm entries for each stage (6 stages + total equilibrium score)
  normativeValues.forEach((ageGroup, scores) {
    for (int i = 0; i < scores.length; i++) {
      double score = scores[i];

      // Add the norm entry to the list
      norms.add(Norm(
        type: assessmentType,
        stageNumber: i + 1,
        ageRange: ageGroup,
        gender: Gender.MALE,
        scoreSum: score * 30,
        trialSum: 30,
      ));
      norms.add(Norm(
        type: assessmentType,
        stageNumber: i + 1,
        ageRange: ageGroup,
        gender: Gender.FEMALE,
        scoreSum: score * 30,
        trialSum: 30,
      ));
    }

    // And save this to the database
    // norms.forEach((norm) {
    //   Amplify.API.mutate(
    //     request: ModelMutations.create(norm),
    //   );
    // });
  });

  return norms;
}
