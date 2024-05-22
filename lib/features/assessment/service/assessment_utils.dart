import 'package:visualpt/features/assessment/config/berg/berg.dart';
import 'package:visualpt/features/assessment/config/ctsib/ctsib.dart';
import 'package:visualpt/features/assessment/config/fist/fist.dart';
import 'package:visualpt/features/assessment/config/gait/gait.dart';
import 'package:visualpt/features/assessment/config/reach/reach.dart';
import 'package:visualpt/features/assessment/view/assessment_view.dart';
import 'package:visualpt/features/inference/service/pose_classification/pose_class_output.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/inference/view/pose_detection_indicator.dart';
import 'package:visualpt/models/AssessmentType.dart';
import 'package:visualpt/models/Detection.dart';

class AssessmentUtils {
  static AssessmentView getView(AssessmentType type) {
    switch (type) {
      case AssessmentType.CTSIB:
        return AssessmentView(CTSIB());
      case AssessmentType.BERG:
        return AssessmentView(BERG());
      case AssessmentType.GAIT:
        return AssessmentView(GAIT());
      case AssessmentType.REACH:
        return AssessmentView(REACH());
      case AssessmentType.FIST:
        return AssessmentView(FIST());
    }
  }

  static linkOutput(
      Map<DeviceCapture, PoseDetectionOutput> detections,
      Map<PoseDetectionOutput, PoseClassificationOutput> classifications,
      Map<String, dynamic> params) {
    final linked = <Detection>[];
    detections.forEach((key, value) {
      final classification = classifications[value];
      if (classification != null) {
        linked.add(Detection(
          version: 1,
          id: key.id,
          obtrustion: params["obtrustion"],
          instability: params["instability"],
          env: key.measurements,
          keypoints: value.toString(),
          prediction: classification.toString(),
        ));
      }
    });
    return linked;
  }
}
