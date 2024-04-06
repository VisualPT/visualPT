import 'package:camera/camera.dart';
import 'package:visualpt_collector/features/assessment/config/berg/berg.dart';
import 'package:visualpt_collector/features/assessment/config/ctsib/ctsib.dart';
import 'package:visualpt_collector/features/assessment/config/gait/gait.dart';
import 'package:visualpt_collector/features/assessment/view/assessment_view.dart';
import 'package:visualpt_collector/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt_collector/models/AssessmentType.dart';

class AssessmentUtils {
  static createPayload(AssessmentType? path, CameraImage input,
      PoseDetectionOutput output, Map<String, dynamic>? params) {
    return switch (path) {
      AssessmentType.CTSIB => CTSIBData(
          input.height,
          input.width,
          params!["ratio"],
          params["class"] ?? -1,
          params["condition"] ?? -1,
          params["trial"] ?? -1,
          output,
        ).toCSV(),
      AssessmentType.BERG => BERGData(
          input.height,
          input.width,
          params!["ratio"],
          params["class"] ?? -1,
          params["condition"] ?? -1,
          params["trial"] ?? -1,
          output,
        ).toCSV(),
      AssessmentType.GAIT => GAITData(
          input.height,
          input.width,
          params!["ratio"],
          params["trial"] ?? -1,
          //output,
        ).toCSV(),
      null => throw Exception(
          "Path not set and making it to this part of the code BAD BAD BAD BAD BAD BAD BAD BAD"),
    };
  }

  static AssessmentView getView(AssessmentType type) {
    switch (type) {
      case AssessmentType.CTSIB:
        return AssessmentView(CTSIB());
      case AssessmentType.BERG:
        return AssessmentView(BERG());
      case AssessmentType.GAIT:
        // return AssessmentView(GAIT());
        break;
    }
    throw Exception("Invalid Assessment Type for requested type T");
  }
}
