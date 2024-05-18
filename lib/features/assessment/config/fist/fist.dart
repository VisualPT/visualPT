import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/models/AssessmentType.dart';

class FIST implements BaseAssessment {
  @override
  AssessmentType get type => AssessmentType.FIST;

  @override
  String get name => "Function in Sitting Test";

  @override
  String get normalDuration => "5 minutes";

  @override
  String get details =>
      """The Function in Sitting Test (FIST) assesses functional sitting abilities and tracks changes in sitting balance over time""";

  @override
  String get imagePath => "assets/images/fist_mainlogo.png";

  @override
  int get sequences => 1;

  @override
  List<String> get seqNames => ["Sitting"];

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
