import 'dart:math';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/features/inference/service/pose_classification/pose_class_output.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';

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
      """Clinical Test of Sensory Integration & Balance is a test used to assess the sensory integration of balance. \n\nThe test is used to identify the sensory system that is contributing to balance deficits.\n\nThe test is performed in a quiet environment with the subject standing on a firm surface with eyes open, eyes closed, and with a visual conflict dome.\n\nThe test is then repeated with the subject standing on a foam surface.""";

  @override
  String get imagePath => "assets/images/ctsib_mainlogo.png";

  @override
  int get conditions => 6;

  @override
  int get trials => 1;

  @override
  int get trialDuration => 20;

  @override
  List<String> get conditionNames => [
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
  List<List<String>> get conditionInstructions => List.filled(conditions, [
        "Patients' landmark boundaries must be as close to the fixed bounding box as possible",
        "Camera position must be static and level",
        "Lighting must be sufficient to clearly see the subject",
      ]);

  @override
  List<List<InferenceType>> get conditionInference => List.filled(conditions,
      [InferenceType.poseDetection, InferenceType.poseClassification]);

  @override
  List<bool> get conditionObtrusion => [false, false, false, true, true, true];

  @override
  List<bool> get conditionInstability =>
      [false, false, true, false, false, true];

  @override
  Map<Map<String, String>, String> get formFields => {};

  @override
  bool get isTrainingData => true;

  @override
  bool get isAvailable => true;

  @override
  Future<List<Norm>?> getNorms(TemporalDate dob, Gender gender) async {
    try {
      final AgeRange ageRange = getAgeEnumByTemporalDate(dob);
      final request = ModelQueries.list(Norm.classType,
          where: Norm.TYPE
              .eq(AssessmentType.CTSIB)
              .and(Norm.AGE_RANGE.eq(ageRange).and(Norm.GENDER.eq(gender))));
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
      final existingNorm = existingNorms
          ?.firstWhere((element) => element.sequenceNumber == seqNum);

      if (existingNorm != null) {
        final request = ModelMutations.update(existingNorm.copyWith(
          score_sum: existingNorm.score_sum + score,
          trial_sum: existingNorm.trial_sum + trials,
        ));
        final response = await Amplify.API.mutate(request: request).response;
        return response.data;
      } else {
        final newNorm = Norm(
          type: AssessmentType.CTSIB,
          age_range: getAgeEnumByTemporalDate(dob),
          gender: gender,
          sequenceNumber: seqNum,
          score_sum: score,
          trial_sum: trials,
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
    final validConditions = assessment.Conditions?.where((condition) =>
                condition.trials != null && condition.trials!.isNotEmpty)
            .toList() ??
        [];

    try {
      final conditionScores = validConditions.map((condition) {
        final trialsCountAndScoreSum = condition.trials!.fold<(int, double)>(
            (0, 0.0), (trialsCountAndScoreIterator, trial) {
          if (trial.Detections == null || trial.Detections!.isEmpty) {
            return trialsCountAndScoreIterator;
          }
          final detectionCountAndScoreSum = trial.Detections!
              .fold<(int, double)>((0, 0.0),
                  (detectionCountAndScoreIterator, detection) {
            final poseOutput =
                PoseDetectionOutput.fromString(detection.keypoints);
            final (xSway, zSway) = PoseDetectionOutput.computeAngles(
                poseOutput.map((e) => (e[0], e[1], e[2])).toList());
            final latProportion = xSway / swayLimits[2];
            //If the subject is leaning forward, the angle will be negative, so use the anterior sway limit
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
      return List.generate(validConditions.length, (index) => 0.0,
          growable: false);
    }
  }

  @override
  String getNormativeMessage(Assessment assessment, List<Norm>? norms) {
    final globalScores = norms
            ?.map((s) => s.trial_sum == 0 ? 0 : s.score_sum / s.trial_sum)
            .reduce((a, b) => (a) + (b)) ??
        0.0;
    final localScores = assessment.Conditions?.map((s) => s.trials?.fold(0.0,
                (previousValue, element) => previousValue + element.duration))
            .reduce((a, b) => (a ?? 0.0) + (b ?? 0.0)) ??
        0.0;
    final percent = ((localScores - globalScores) / globalScores) * 100;

    return "Patients total score is $localScores. The global norm is $globalScores, which is ${percent.abs()}% of age gender norms";
  }

  //Numbers are in m/s and start in the 6-12, then 13-19, then 20-29, 30-39... to 80+
  // static const norms = [179.7, 180.0, 179.9, 177.7];
  // static const ageGroups = [20, 49, 59, 69, 79];

  static List<(double, double)> averageSwayPerCondition(Assessment assessment) {
    // Filter out null conditions and conditions without trials
    final validConditions = assessment.Conditions?.where((condition) =>
                condition.trials != null && condition.trials!.isNotEmpty)
            .toList() ??
        [];

    return validConditions.map((condition) {
      // Calculate total sway and count of detections
      final totalAndCount = condition.trials!.fold<(int, (double, double))>(
          (0, (0.0, 0.0)), (previousValue, trial) {
        if (trial.Detections == null || trial.Detections!.isEmpty) {
          return previousValue;
        }
        final trialTotalAndCount = trial.Detections!
            .fold<(int, (double, double))>((0, (0.0, 0.0)),
                (averageAngle, detection) {
          final poseOutput =
              PoseDetectionOutput.fromString(detection.keypoints);
          final angle = PoseDetectionOutput.computeAngles(
              poseOutput.map((e) => (e[0], e[1], e[2])).toList());

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
      // Calculate and return the average sway for this condition
      return (
        totalAndCount.$2.$1 / totalAndCount.$1,
        totalAndCount.$2.$2 / totalAndCount.$1
      );
    }).toList();
  }

  static List<(double, double)> maxSwayPerCondition(Assessment assessment) {
    // Filter out null conditions and conditions without trials
    final validConditions = assessment.Conditions?.where((condition) =>
                condition.trials != null && condition.trials!.isNotEmpty)
            .toList() ??
        [];

    return validConditions.map((condition) {
      // Calculate total sway and count of detections
      final maxSway = condition.trials!.fold<(double, double)>((0.0, 0.0),
          (previousValue, trial) {
        if (trial.Detections == null || trial.Detections!.isEmpty) {
          return previousValue;
        }
        final trialMaxSway = trial.Detections!
            .fold<(double, double)>((0.0, 0.0), (maxAngle, detection) {
          final poseOutput =
              PoseDetectionOutput.fromString(detection.keypoints);
          final (lat, lng) = PoseDetectionOutput.computeAngles(
              poseOutput.map((e) => (e[0], e[1], e[2])).toList());

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
    // Filter out null conditions and conditions without trials
    final validConditions = assessment.Conditions?.where((condition) =>
                condition.trials != null && condition.trials!.isNotEmpty)
            .toList() ??
        [];

    return validConditions.map((condition) {
      // Initialize the list for counting predictions
      final totalPredictions = List<int>.filled(5, 0);

      // Iterate over each trial
      for (int i = 0; i < condition.trials!.length; i++) {
        final trial = condition.trials![i];
        if (trial.Detections != null && trial.Detections!.isNotEmpty) {
          // Iterate over each detection
          for (int j = 0; j < trial.Detections!.length; j++) {
            final detection = trial.Detections![j];
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

  static getMostFrequentClassification(Assessment assessment, int i) {
    return classifications[CTSIB.getPredictionTotals(assessment)[i].indexWhere(
        (value) =>
            value ==
            CTSIB
                .getPredictionTotals(assessment)[i]
                .reduce((a, b) => a > b ? a : b))];
  }

  static String getMostFrequentIndexAcrossAllEntries(
      List<List<int>> predictionTotals) {
    // Initialize a map to count the frequency of each index
    Map<int, int> indexFrequency = {};

    // Iterate over each sublist
    for (var sublist in predictionTotals) {
      for (int i = 0; i < sublist.length; i++) {
        if (!indexFrequency.containsKey(i)) {
          indexFrequency[i] = 0;
        }
        indexFrequency[i] = indexFrequency[i]! + sublist[i];
      }
    }

    // Find the index with the highest frequency
    int mostFrequentIndex = -1;
    int highestFrequency = -1;

    indexFrequency.forEach((index, frequency) {
      if (frequency > highestFrequency) {
        highestFrequency = frequency;
        mostFrequentIndex = index;
      }
    });

    return classifications[mostFrequentIndex]?.toString() ?? "invalid";
  }
}

//Anterior, Posterior, Lat
const swayLimits = [8.0, 4.5, 8.0];
