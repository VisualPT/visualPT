import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:visualpt/features/assessment/config/ctsib/ctsib.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
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
      """Modified Clinical Test of Sensory Integration & Balance is a test used to assess the sensory integration of balance. \n\nThe test is used to identify the sensory system that is contributing to balance deficits.\n\nThe test is performed in a quiet environment with the subject standing on a firm surface with eyes open, eyes closed.\n\nThe test is then repeated with the subject standing on a foam surface. It is considered modified since it does not test the visual conflict dome conditions""";

  @override
  String get imagePath => "assets/images/ctsib_mainlogo.png";

  @override
  int get conditions => 4;

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
  List<List<String>> get conditionInstructions => List.filled(conditions, [
        "Patients' landmark boundaries must be as close to the fixed bounding box as possible",
        "Camera position must be static and level",
        "Lighting must be sufficient to clearly see the subject",
      ]);

  @override
  List<List<InferenceType>> get conditionInference =>
      List.filled(conditions, [InferenceType.poseDetection]);

  @override
  List<bool> get conditionObtrusion => [false, false, true, true];

  @override
  List<bool> get conditionInstability => List.filled(4, false);

  @override
  Map<Map<String, String>, String> get formFields => {};

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
            final (xSway, _) = PoseDetectionOutput.computeAngles(
                poseOutput.map((e) => (e[0], e[1], e[2])).toList(),
                AccelerometerEvent(
                    detection.env.accX ?? 0,
                    detection.env.accY ?? 0,
                    detection.env.accZ ?? 0,
                    detection.env.timestamp?.getDateTimeInUtc().toLocal() ??
                        DateTime.now()));
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

  @override
  bool isComplete(args) {
    args as PoseDetectionOutput;
    final (isFall, __) = CTSIB.poseToCtsibData(args.toString(),
        args.accelData ?? AccelerometerEvent(0, 0, 0, DateTime.now()));
    return isFall;
  }
}
