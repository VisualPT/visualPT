import 'dart:ui';
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

  //Numbers are in m/s and start in the 6-12, then 13-19, then 20-29, 30-39... to 80+
  static const norms = [179.7, 180.0, 179.9, 177.7];
  static const ageGroups = [20, 49, 59, 69, 79];

  static double getAgeNorm(int age) {
    final int index = ageGroups.indexWhere((element) => element > age);
    return norms[index];
  }

  static List<double> averageSwayPerCondition(Assessment assessment) {
    // Filter out null conditions and conditions without trials
    final validConditions = assessment.Conditions?.where((condition) =>
                condition.trials != null && condition.trials!.isNotEmpty)
            .toList() ??
        [];

    return validConditions.map((condition) {
      // Calculate total sway and count of detections
      final totalAndCount = condition.trials!.fold<(int, double)>((0, 0.0),
          (previousValue, trial) {
        if (trial.Detections == null || trial.Detections!.isEmpty) {
          return previousValue;
        }
        final trialTotalAndCount = trial.Detections!
            .fold<(int, double)>((0, 0.0), (trialPreviousValue, detection) {
          final poseOutput =
              PoseDetectionOutput.fromString(detection.keypoints);
          final angle = PoseDetectionOutput.computeAngle(
              poseOutput.map((e) => Offset(e[0], e[1])).toList());

          return (trialPreviousValue.$1 + 1, trialPreviousValue.$2 + angle);
        });
        return (
          previousValue.$1 + trialTotalAndCount.$1,
          previousValue.$2 + trialTotalAndCount.$2
        );
      });

      if (totalAndCount.$1 == 0) {
        return 0.0;
      }
      // Calculate and return the average sway for this condition
      return totalAndCount.$2 / totalAndCount.$1;
    }).toList();
  }

  static List<double> maxSwayPerCondition(Assessment assessment) {
    // Filter out null conditions and conditions without trials
    final validConditions = assessment.Conditions?.where((condition) =>
                condition.trials != null && condition.trials!.isNotEmpty)
            .toList() ??
        [];

    return validConditions.map((condition) {
      // Calculate total sway and count of detections
      final maxSway =
          condition.trials!.fold<double>(0.0, (previousValue, trial) {
        if (trial.Detections == null || trial.Detections!.isEmpty) {
          return previousValue;
        }
        final trialMaxSway = trial.Detections!.fold<double>(0.0,
            (trialPreviousValue, detection) {
          final poseOutput =
              PoseDetectionOutput.fromString(detection.keypoints);
          final angle = PoseDetectionOutput.computeAngle(
              poseOutput.map((e) => Offset(e[0], e[1])).toList());

          return trialPreviousValue > angle ? trialPreviousValue : angle;
        });

        return previousValue > trialMaxSway ? previousValue : trialMaxSway;
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
