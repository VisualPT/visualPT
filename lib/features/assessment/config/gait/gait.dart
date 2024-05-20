import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/core/utils/amplify_utils.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';
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
      """The Gait Velocity Test is a quick and easy way to assess a subject's walking speed. \nThe test is performed by having the subject walk a set distance and measuring the time it takes to complete the distance.""";

  @override
  String get imagePath => "assets/images/gv_mainlogo.png";

  @override
  int get conditions => 1;

  @override
  int get trials => 1;

  @override
  List<String> get conditionNames => ["Walk"];

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
}

class GaitNorms {
  GaitNorms._();
  //Numbers are in m/s and start in the 6-12, then 13-19, then 20-29, 30-39... to 80+
  static const maleNorm = [1.19, 1.2, 1.4, 1.48, 1.48, 1.4, 1.39, 1.34, 1.1];
  static const femaleNorm = [1.14, 1.2, 1.4, 1.4, 1.4, 1.39, 1.22, 1.19, 1.0];

  static double getVelocityFromAge(Gender gender, TemporalDate dob) {
    int age = getAge(dob);
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
//   late String lastname = 'subject';
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
  //final Patient subject; TODO: #140 Implement Patient Row in the Metadata @DrBubbles42 this should probably become a third row
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
