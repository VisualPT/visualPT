import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/models/ModelProvider.dart';

class BERG implements BaseAssessment {
  @override
  AssessmentType get type => AssessmentType.BERG;

  @override
  String get name => "Berg Balance Scale";

  @override
  String get normalDuration => "5 minutes";

  @override
  String get details =>
      """Test of a person's static and dynamic balance abilities.\n\nThe test is used to identify balance deficits in the elderly and in patients with neurological stages.""";

  @override
  String get imagePath => "assets/images/berg_mainlogo.png";

  @override
  String get stageGifPath => ""; //TODO

  @override
  String get stageLabel => "Stage";

  @override
  int get stages => 6;

  @override
  int get trials => 1;

  @override
  int get trialDuration => 30;

  @override
  List<String> get stageNames => [
        "Standing Unsupported with Feet Together",
        "Standing on One Leg",
        "Pick Up Object from the Floor",
        "Turning to Look Over Left and Right Shoulders",
        "Turning 360 Degrees",
        "Sitting Down",
      ];

  @override
  List<List<String>> get stageInstructions => List.filled(6, [
        "Hold the camera steady and level",
        "Only one person should be in the frame at a time",
      ]);

  @override
  List<bool> get stageObtrusion => [false, false, false, false, false, false];

  @override
  List<bool> get stageInstability => [false, false, false, false, false, false];

  @override
  Map<String, FormFieldItem> get formFields => {};

  @override
  bool get isTrainingData => true;

  @override
  bool get isAvailable => true;

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
