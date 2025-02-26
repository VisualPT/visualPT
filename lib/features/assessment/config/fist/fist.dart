import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/models/ModelProvider.dart';

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
  String get stageGifPath => ""; //TODO

  @override
  int get stages => 1;

  @override
  int get trials => 1;

  @override
  int get trialDuration => 30;

  @override
  List<String> get conditionNames => ["Sitting"];

  @override
  List<List<String>> get conditionInstructions => List.filled(1, [
        "Hold the camera steady and level",
        "Only one person should be in the frame at a time",
      ]);

  @override
  List<bool> get conditionObtrusion => [false];

  @override
  List<bool> get conditionInstability => [false];

  @override
  Map<String, FormFieldItem> get formFields => {};

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
  bool isComplete(Detection? detection) {
    if (detection == null) {
      return true; // Person MUST be detected during the full assessment for it to be complete
    }
    return false;
  }
}
