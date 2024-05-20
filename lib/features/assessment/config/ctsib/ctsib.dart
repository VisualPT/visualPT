import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';

import 'package:visualpt/models/ModelProvider.dart';

class CTSIB implements BaseAssessment {
  @override
  AssessmentType get type => AssessmentType.CTSIB;

  @override
  String get name => "Clinical Test of Sensory Interaction on Balance";

  @override
  String get normalDuration => "5 minutes";

  @override
  get details =>
      """The Clinical Test of Sensory Interaction on Balance (CTSIB) is a test used to assess the sensory integration of balance. \n\nThe test is used to identify the sensory system that is contributing to balance deficits.\n\nThe test is performed in a quiet environment with the subject standing on a firm surface with eyes open, eyes closed, and with a visual conflict dome.\n\nThe test is then repeated with the subject standing on a foam surface.""";

  @override
  String get imagePath => "assets/images/ctsib_mainlogo.png";

  @override
  int get conditions => 6;

  @override
  int get trials => 1;

  @override
  List<String> get conditionNames => [
        "Eyes Open, Firm Surface",
        "Eyes Closed, Firm Surface",
        "Visual Conflict Dome, Firm Surface",
        "Eyes Open, Foam Surface",
        "Eyes Closed, Foam Surface",
        "Visual Conflict Dome, Foam Surface",
      ];

  @override
  List<List<String>> get conditionInstructions => List.filled(6, [
        "Patients' landmark boundaries must be as close to the fixed bounding box as possible",
        "Camera position must be static and level",
        "Lighting must be sufficient to clearly see the subject",
      ]);

  @override
  List<List<InferenceType>> get conditionInference => List.filled(
      6, [InferenceType.poseDetection, InferenceType.poseClassification]);

  @override
  List<bool> get conditionObtrusion => [false, false, false, true, true, true];

  @override
  List<bool> get conditionInstability =>
      [false, false, true, false, false, true];

  @override
  Map<Map<String, String>, String> get formFields => {};

  @override
  bool get isTrainingData => true;

  @override
  bool get isAvailable => true;

  //Numbers are in m/s and start in the 6-12, then 13-19, then 20-29, 30-39... to 80+
  static const norms = [179.7, 180.0, 179.9, 177.7];
  static const ageGroups = [20, 49, 59, 69, 79];

  static double getAgeNorm(int age) {
    final int index = ageGroups.indexWhere((element) => element > age);
    return norms[index];
  }
}

class CTSIBData {
  //Image Data
  final num imageHeight;
  final num imageWidth;
  //Inference Data
  final int classIndex;
  final int conditionNumber;
  final int trialNumber;
  final PoseDetectionOutput output;
  const CTSIBData(
    this.imageHeight,
    this.imageWidth,
    this.classIndex,
    this.conditionNumber,
    this.trialNumber,
    this.output,
  );

  toCSV() {
    final lines = output.output.map((line) => line.join(",")).join("\n");
    final metadata = [
      imageHeight,
      imageWidth,
      classIndex,
      conditionNumber,
      trialNumber
    ].join(",");
    return '$metadata\n$lines';
  }
}
