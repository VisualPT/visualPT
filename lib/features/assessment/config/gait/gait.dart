import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/models/ModelProvider.dart';

class GAIT implements BaseAssessment {
  @override
  AssessmentType get type => AssessmentType.GAIT;

  @override
  String get name => "Gait Velocity Test";

  @override
  String get normalDuration => "5 minutes";

  @override
  String get details =>
      """The Gait Velocity Test is a quick and easy way to assess a profile's walking speed. \nThe test is performed by having the profile walk a set distance and measuring the time it takes to complete the distance.""";

  @override
  String get imagePath => "assets/images/gv_mainlogo.png";

  @override
  String get stageGifPath => ""; //TODO

  @override
  String get stageLabel => "Stage";

  @override
  int get stages => 1;

  @override
  int get trials => 1;

  @override
  int get trialDuration => 30;

  @override
  List<String> get stageNames => ["Walk"];

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

class GaitNorms {
  GaitNorms._();
  //Numbers are in m/s and start in the 6-12, then 13-19, then 20-29, 30-39... to 80+
  static const maleNorm = [1.19, 1.2, 1.4, 1.48, 1.48, 1.4, 1.39, 1.34, 1.1];
  static const femaleNorm = [1.14, 1.2, 1.4, 1.4, 1.4, 1.39, 1.22, 1.19, 1.0];

  static double getVelocityFromAge(Gender gender, TemporalDate dob) {
    int age = FormatUtil.getAge(dob);
    final int index = (age / 10).round().clamp(0, 8);
    return gender == Gender.MALE ? maleNorm[index] : femaleNorm[index];
  }

  static double getPercentDifferenceFromNorm(
      double patientVelocity, Gender gender, TemporalDate dob) {
    final double normVelocity = getVelocityFromAge(gender, dob);
    return (((patientVelocity - normVelocity) /
                ((patientVelocity + normVelocity) / 2)) *
            100)
        .roundToDouble();
  }
}

// class GaitPatientData {
//   late String managingtherapistEmail = 'sample@example.com';
//   late String firstname = 'sample';
//   late String lastname = 'profile';
//   late String bday = '01/01/1901';
//   late bool isMale = true;
//   late String age = '0';
//   late String date = '01/01/1901';
//   late String time = '00:00';
//   late String velocity = "1.0";
//   late double measurementDuration = 0.0;
//   late bool isVideo = true;
//   late String rawReportData = 'sample';
// }

class GAITData {
  final num imageHeight;
  final num imageWidth;
  //final int classIndex;
  //final int conditionNumber;
  final int trialNumber;
  //final Patient profile; TODO: #140 Implement Patient Row in the Metadata @DrBubbles42 this should probably become a third row
  //final GaitDetectionOutput output;
  const GAITData(
    this.imageHeight,
    this.imageWidth,
    //this.classIndex,
    //this.conditionNumber,
    this.trialNumber,
    //this.output,
  );
  toCSV() {
    //final lines = output.output.map((line) => line.join(",")).join("\n");
    final metadata = [
      imageHeight,
      imageWidth,
      //classIndex,
      //conditionNumber,
      trialNumber
    ].join(",");
    return metadata;
  }
}
