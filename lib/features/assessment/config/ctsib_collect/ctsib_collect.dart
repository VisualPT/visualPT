import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';

import 'package:visualpt/models/ModelProvider.dart';

class CTSIB_COLLECT implements BaseAssessment {
  @override
  AssessmentType get type => AssessmentType.CTSIB_COLLECT;

  @override
  String get name =>
      "Clinical Test of Sensory Integration & Balance Data Collection";

  @override
  String get normalDuration => "10 minutes";

  @override
  get details =>
      """Clinical Test of Sensory Integration & Balance is a test used to assess the sensory integration of balance. \n\nThe test is used to identify the sensory system that is contributing to balance deficits.\n\nThis assessment specifically uses the 4th condition, which presents the most difficult challenge to a healthy individual. The subject stands on a foam surface with eyes closed.""";

  @override
  String get imagePath => "assets/images/ctsib_mainlogo.png";

  @override
  int get conditions => 1;

  @override
  int get trials => 3;

  @override
  List<String> get conditionNames => [
        "Eyes Closed, Foam Surface",
      ];

  @override
  List<List<String>> get conditionInstructions => List.filled(conditions, [
        "Patients' landmark boundaries must be as close to the fixed bounding box as possible",
        "Camera position must be static and level",
        "Lighting must be sufficient to clearly see the subject",
      ]);

  @override
  List<List<InferenceType>> get conditionInference => [
        [InferenceType.poseDetection, InferenceType.poseClassification]
      ];

  @override
  List<bool> get conditionObtrusion => [false];

  @override
  List<bool> get conditionInstability => [false];

  @override
  Map<Map<String, String>, String> get formFields => {};

  @override
  bool get isTrainingData => true;

  @override
  bool get isAvailable => true;
}
