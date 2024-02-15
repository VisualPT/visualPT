import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/models/ModelProvider.dart';

class CTSIB extends BaseAssessment {
  CTSIB()
      : super(
          type: AssessmentType.CTSIB,
          sequences: 6,
          seqNames: [
            "Eyes Open, Firm Surface",
            "Eyes Closed, Firm Surface",
            "Visual Conflict Dome, Firm Surface",
            "Eyes Open, Foam Surface",
            "Eyes Closed, Foam Surface",
            "Visual Conflict Dome, Foam Surface",
          ],
          seqInstructions: List.filled(6, [
            "Patients' landmark boundaries must be as close to the fixed bounding box as possible",
            "Camera position must be static and level",
            "Lighting must be sufficient to clearly see the patient",
          ]),
          seqInference: List.filled(6,
              [InferenceType.poseDetection, InferenceType.poseClassification]),
          formFields: {},
          isTrainingData: true,
        );

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
  final num ratio;
  //Inference Data
  final int classIndex;
  final int conditionNumber;
  final int trialNumber;
  final PoseDetectionOutput output;
  const CTSIBData(
    this.imageHeight,
    this.imageWidth,
    this.ratio,
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
      ratio,
      classIndex,
      conditionNumber,
      trialNumber
    ].join(",");
    return '$metadata\n$lines';
  }
}
