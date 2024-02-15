import 'package:camera/camera.dart';
import 'package:visualpt/features/assessment/view/berg/berg.dart';
import 'package:visualpt/features/assessment/view/ctsib/ctsib.dart';
import 'package:visualpt/features/assessment/view/gait/gait.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/models/AssessmentType.dart';

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
}
