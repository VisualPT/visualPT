import 'dart:developer';
import 'dart:isolate';

import 'package:visualpt/features/inference/service/pose_classification/pose_class_service.dart';

import '../../../core/utils/isolate_utils.dart';
import 'ai_model.dart';
import 'face_detection/face_detection_service.dart';
import 'face_mesh/face_mesh_service.dart';
import 'hands/hands_service.dart';
import 'pose_detection/pose_detection_service.dart';
import 'service_locator.dart';

enum Models {
  FaceDetection,
  FaceMesh,
  Hands,
  PoseDetect,
  PoseClass,
}

class ModelInferenceService<I, O> {
  late AiModel model;
  late Function handler;
  AiModelOutput? inferenceResults;

  Future<void> inference({
    required IsolateUtils isolateUtils,
    required I input,
    required Map<String, dynamic>? params,
  }) async {
    final responsePort = ReceivePort();

    isolateUtils.sendMessage(
      handler: handler,
      params: {
        'input': input,
        'detectorAddress': model.getAddress,
        'params': params,
      },
      sendPort: isolateUtils.sendPort,
      responsePort: responsePort,
    );

    inferenceResults = await responsePort.first;
    responsePort.close();
  }

  void setModelConfig(int index) {
    switch (Models.values[index]) {
      case Models.FaceDetection:
        log("Face Detection model configured");
        model = locator<FaceDetection>();
        handler = runFaceDetector;
        break;
      case Models.FaceMesh:
        log("Face Mesh model configured");
        model = locator<FaceMesh>();
        handler = runFaceMesh;
        break;
      case Models.Hands:
        log("Hands model configured");
        model = locator<Hands>();
        handler = runHandDetector;
        break;
      case Models.PoseDetect:
        log("Pose detection model configured");
        model = locator<PoseDetection>();
        handler = runPoseDetector;
        break;
      case Models.PoseClass:
        log("Pose classification model configured");
        model = locator<PoseClassification>();
        handler = runPoseClassifier;
    }
  }
}
