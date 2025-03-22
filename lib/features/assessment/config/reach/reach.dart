import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/models/Assessment.dart';
import 'package:visualpt/models/AssessmentType.dart';
import 'package:visualpt/models/Detection.dart';
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
      """The Functional Reach Test is a quick and easy way to assess a profile's balance and stability.\n The test is performed by having the profile stand with their feet shoulder-width apart and reaching forward as far as they can without taking a step.""";

  @override
  String get imagePath => ""; //TODO

  @override
  String get stageGifPath => ""; //TODO

  @override
  int get stages => 1;

  @override
  int get trials => 1;

  @override
  int get trialDuration => 30;

  @override
  List<String> get stageNames => ["Reach Forward"];

  @override
  List<List<String>> get stageInstructions => List.filled(1, [
        "Hold the camera steady and level",
        "Only one person should be in the frame at a time",
      ]);

  @override
  List<bool> get stageObtrusion => [false];

  @override
  List<bool> get stageInstability => [false];

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
  List<List<double>> calculateScores(Assessment assessment) {
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
