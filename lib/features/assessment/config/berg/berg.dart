import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/models/ModelProvider.dart';

class BERG extends BaseAssessment {
  BERG()
      : super(
          type: AssessmentType.BERG,
          sequences: 6,
          seqNames: [
            "Standing Unsupported with Feet Together",
            "Standing on One Leg",
            "Pick Up Object from the Floor",
            "Turning to Look Over Left and Right Shoulders",
            "Turning 360 Degrees",
            "Sitting Down",
          ],
          seqInstructions: List.filled(6, [
            "Patients' landmark boundaries must be as close to the fixed bounding box as possible",
            "Camera position must be static and level",
            "Lighting must be sufficient to clearly see the patient",
          ]),
          seqInference: List.filled(6, [InferenceType.poseDetection]),
          seqInstability: [false, false, false, false, false, false],
          seqObtrusion: [false, false, false, false, false, false],
          formFields: {},
          isTrainingData: true,
        );
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
