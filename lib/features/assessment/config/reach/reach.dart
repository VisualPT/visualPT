import 'package:amplify_core/src/types/temporal/temporal_date.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/models/Assessment.dart';
import 'package:visualpt/models/AssessmentType.dart';
import 'package:visualpt/models/Gender.dart';
import 'package:visualpt/models/Norm.dart';

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
  int get conditions => 1;

  @override
  int get trials => 1;

  @override
  int get trialDuration => 30;

  @override
  List<String> get conditionNames => ["Reach Forward"];

  @override
  List<List<String>> get conditionInstructions => List.filled(1, [
        "Patients' landmark boundaries must be as close to the fixed bounding box as possible",
        "Camera position must be static and level",
        "Lighting must be sufficient to clearly see the subject",
      ]);

  @override
  List<List<InferenceType>> get conditionInference =>
      List.filled(1, [InferenceType.poseDetection]);

  @override
  List<bool> get conditionObtrusion => [false];

  @override
  List<bool> get conditionInstability => [false];

  @override
  Map<Map<String, String>, String> get formFields => {};

  @override
  bool get isTrainingData => true;

  @override
  bool get isAvailable => false;

  @override
  Future<List<Norm>?> getNorms(TemporalDate dob, Gender gender) {
    // TODO: implement getNorm
    throw UnimplementedError();
  }

  @override
  Future<Norm?> setNorm(
      TemporalDate dob, Gender gender, int seqNum, double score, int trials) {
    // TODO: implement setNorm
    throw UnimplementedError();
  }

  @override
  List<double> calculateScores(Assessment assessment) {
    // TODO: implement calculateScores
    throw UnimplementedError();
  }

  @override
  String getNormativeMessage(Assessment assessment, List<Norm>? norms) {
    // TODO: implement getNormativeMessage
    throw UnimplementedError();
  }

  @override
  bool isComplete(args) {
    return false;
  }
}
