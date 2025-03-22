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
  String get stageGifPath => ""; //TODO

  @override
  int get stages => 1;

  @override
  int get trials => 1;

  @override
  int get trialDuration =>
      30; //Anything over around 50 seconds will cause issues with the detection storage

  @override
  List<String> get stageNames => [
        "Development",
      ];

  List<String> get surface => [
        "Digital",
      ];

  List<String> get vision => [
        "Computer",
      ];

  @override
  List<List<String>> get stageInstructions => List.filled(stages, [
        "Make this app work!",
      ]);

  @override
  List<bool> get stageObtrusion => [false];

  @override
  List<bool> get stageInstability => [false];

  @override
  Map<String, FormFieldItem> get formFields => {
        //FIXME: This structure causes errors if two assessments fields share the same name...
        //Errors: Warning! Replacing duplicate Field for store data -- this is OK to ignore as long as the field was intentionally replaced
        //Errors: Warning! Ignoring Field unregistration for store data -- this is OK to ignore as long as the field was intentionally replaced
        //TODO: File a bug report with https://github.com/flutter-form-builder-ecosystem/flutter_form_builder and/or figure out how to fix this
        //This assessment only show up in the dev environment, so we dont need to conditionally add the store form field
        // "store data": FormFieldItem<bool>(
        //   form: FormBuilderCupertinoSwitch(
        //       key: const Key("dev_store_data"),
        //       name: "store data",
        //       prefix: const Text("Store Data", style: Styles.prefixStyle),
        //       initialValue: true),
        //   value: true,
        // ),
      };

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
  List<List<double>> calculateScores(Assessment assessment) {
    return [[]];
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
