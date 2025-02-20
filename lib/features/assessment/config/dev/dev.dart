import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/assessment/_assessment.dart';

class DEV implements BaseAssessment {
  @override
  AssessmentType get type => AssessmentType.DEV;

  @override
  String get name => "Development";

  @override
  String get normalDuration => "X minutes";

  @override
  get details =>
      """For testing with fine control over the assessment parameters""";

  @override
  String get imagePath => "assets/images/vpt_appicon.png";

  @override
  int get stages => 1;

  @override
  int get trials => 1;

  @override
  int get trialDuration => 6000000;

  @override
  List<String> get conditionNames => [
        "Development",
      ];

  List<String> get surface => [
        "Digital",
      ];

  List<String> get vision => [
        "Computer",
      ];

  @override
  List<List<String>> get conditionInstructions => List.filled(stages, [
        "Make this app work!",
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
  bool get isAvailable => true;

  @override
  Future<List<Norm>?> getNorms(TemporalDate dob, Gender gender) async {
    return null;
  }

  @override
  Future<Norm?> setNorm(TemporalDate dob, Gender gender, int seqNum,
      double score, int trials) async {
    return null;
  }

  @override
  List<double> calculateScores(Assessment assessment) {
    return [];
  }

  @override
  String getNormativeMessage(Assessment assessment, List<Norm>? norms) {
    return "";
  }

  @override
  bool isComplete(Detection? detection) {
    return false;
  }
}
