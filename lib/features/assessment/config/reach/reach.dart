import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/models/AssessmentType.dart';

class REACH implements BaseAssessment {
  @override
  AssessmentType get type => AssessmentType.REACH;

  @override
  String get name => "Functional Reach Test";

  @override
  String get normalDuration => "5 minutes";

  @override
  String get details =>
      """The Functional Reach Test is a quick and easy way to assess a subject's balance and stability.\n The test is performed by having the subject stand with their feet shoulder-width apart and reaching forward as far as they can without taking a step.""";

  @override
  String get imagePath => "assets/images/reach_mainlogo.png";

  @override
  int get sequences => 1;

  @override
  List<String> get seqNames => ["Reach Forward"];

  @override
  List<List<String>> get seqInstructions => List.filled(1, [
        "Patients' landmark boundaries must be as close to the fixed bounding box as possible",
        "Camera position must be static and level",
        "Lighting must be sufficient to clearly see the subject",
      ]);

  @override
  List<List<InferenceType>> get seqInference =>
      List.filled(1, [InferenceType.poseDetection]);

  @override
  List<bool> get seqObtrusion => [false];

  @override
  List<bool> get seqInstability => [false];

  @override
  Map<Map<String, String>, String> get formFields => {};

  @override
  bool get isTrainingData => true;

  @override
  bool get isAvailable => false;
}
