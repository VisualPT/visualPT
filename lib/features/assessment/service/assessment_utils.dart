import 'package:visualpt/features/assessment/config/berg/berg.dart';
import 'package:visualpt/features/assessment/config/ctsib/ctsib.dart';
import 'package:visualpt/features/assessment/config/dev/dev.dart';
import 'package:visualpt/features/assessment/config/fist/fist.dart';
import 'package:visualpt/features/assessment/config/gait/gait.dart';
import 'package:visualpt/features/assessment/config/mctsib/mctsib.dart';
import 'package:visualpt/features/assessment/config/reach/reach.dart';
import 'package:visualpt/features/assessment/view/assessment_view.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/inference/view/pose_detection_indicator.dart';
import 'package:visualpt/models/Assessment.dart';
import 'package:visualpt/models/AssessmentType.dart';
import 'package:visualpt/models/Detection.dart';
import 'package:visualpt/models/Trial.dart';

class AssessmentUtils {
  static AssessmentView getView(AssessmentType type) {
    switch (type) {
      case AssessmentType.CTSIB:
        return AssessmentView(CTSIB());
      case AssessmentType.MCTSIB:
        return AssessmentView(MCTSIB());
      case AssessmentType.BERG:
        return AssessmentView(BERG());
      case AssessmentType.GAIT:
        return AssessmentView(GAIT());
      case AssessmentType.REACH:
        return AssessmentView(REACH());
      case AssessmentType.FIST:
        return AssessmentView(FIST());
      case AssessmentType.DEV:
        return AssessmentView(DEV());
    }
  }

  static formatOutput(Map<DeviceCapture, PoseDetectionOutput> detections,
      Map<String, dynamic> params) {
    final linked = <Detection>[];
    detections.forEach((key, value) {
      linked.add(Detection(
        version: 1,
        id: key.id,
        obtrustion: params["obtrustion"],
        instability: params["instability"],
        env: key.measurements,
        keypoints: value.toString(),
        prediction: null,
      ));
    });
    return linked.isNotEmpty ? linked : null;
  }

  static double getAvgDuration(List<Trial>? trials) {
    return trials?.fold<double>(0.0,
            (previousValue, element) => previousValue + element.duration) ??
        0.0 / (trials?.length ?? 1);
  }

  static double getTotalAverageDuration(Assessment assessment) {
    if (assessment.Conditions == null || assessment.Conditions!.isEmpty) {
      return 0.0;
    }

    double totalDuration = 0.0;

    for (var condition in assessment.Conditions!) {
      if (condition.trials != null && condition.trials!.isNotEmpty) {
        double conditionTotalDuration = condition.trials!
            .map((trial) => trial.duration)
            .reduce((a, b) => a + b);
        double conditionAverageDuration =
            conditionTotalDuration / condition.trials!.length;
        totalDuration += conditionAverageDuration;
      }
    }

    return totalDuration;
  }
}
