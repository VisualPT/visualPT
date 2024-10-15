import 'dart:developer';
import 'dart:isolate';

import 'package:visualpt/core/utils/isolate_utils.dart';
import 'package:visualpt/features/inference/service/pose_classification/pose_class_service.dart';
import 'package:visualpt/features/inference/service/service_locator.dart';
import 'ai_model.dart';
import 'face_detection/face_detection_service.dart';
import 'face_mesh/face_mesh_service.dart';
import 'hands/hands_service.dart';
import 'pose_detection/pose_detection_service.dart';

enum Models {
  FaceDetection,
  FaceMesh,
  Hands,
  PoseDetect,
  PoseClass,
}

class ModelInferenceService<I, O> {
  late AiModel model;
  late AiModelOutput? Function(
    Map<String, dynamic> params,
  ) handler;

  Future<AiModelOutput?> inference({
    required IsolateUtils isolateUtils,
    required Map<String, dynamic> params,
  }) async {
    final responsePort = ReceivePort();
    // print("Sending $handler, with params: $params");
    isolateUtils.sendMessage(
      handler: handler,
      params: params,
      sendPort: isolateUtils.sendPort,
      responsePort: responsePort,
    );

    final results = await responsePort.first;
    //responsePort.close();
    return results;
  }

  void setModelConfig(int index) {
    switch (Models.values[index]) {
      case Models.FaceDetection:
        log("Face Detection model configured");
        model = locator<FaceDetection>();
        break;
      case Models.FaceMesh:
        log("Face Mesh model configured");
        model = locator<FaceMesh>();
        break;
      case Models.Hands:
        log("Hands model configured");
        model = locator<Hands>();
        break;
      case Models.PoseDetect:
        log("Pose detection model configured");
        model = locator<PoseDetection>();
        break;
      case Models.PoseClass:
        log("Pose classification model configured");
        model = locator<PoseClassification>();
    }
    handler = model.predict;
  }
}
