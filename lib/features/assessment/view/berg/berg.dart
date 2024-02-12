import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/models/ModelProvider.dart';

class BERG extends BaseAssessment {
  BERG()
      : super(
          type: AssessmentType.CTSIB,
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
          formFields: {},
          isTrainingData: true,
        );
}
