import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
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
      """Test of a person's static and dynamic balance abilities.\n\nThe test is used to identify balance deficits in the elderly and in patients with neurological conditions.""";

  @override
  String get imagePath => "assets/images/berg_mainlogo.png";

  @override
  int get sequences => 6;

  @override
  List<String> get seqNames => [
        "Standing Unsupported with Feet Together",
        "Standing on One Leg",
        "Pick Up Object from the Floor",
        "Turning to Look Over Left and Right Shoulders",
        "Turning 360 Degrees",
        "Sitting Down",
      ];

  @override
  List<List<String>> get seqInstructions => List.filled(6, [
        "Patients' landmark boundaries must be as close to the fixed bounding box as possible",
        "Camera position must be static and level",
        "Lighting must be sufficient to clearly see the patient",
      ]);

  @override
  List<List<InferenceType>> get seqInference =>
      List.filled(6, [InferenceType.poseDetection]);

  @override
  List<bool> get seqObtrusion => [false, false, false, false, false, false];

  @override
  List<bool> get seqInstability => [false, false, false, false, false, false];

  @override
  Map<Map<String, String>, String> get formFields => {};

  @override
  bool get isTrainingData => true;

  @override
  bool get isAvailable => true;
}

class BERGData {
  final num imageHeight;
  final num imageWidth;
  final int classIndex;
  final int conditionNumber;
  final int trialNumber;
  final PoseDetectionOutput output;
  const BERGData(
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
    return "$metadata\n$lines";
  }
}
