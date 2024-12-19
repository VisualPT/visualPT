import 'dart:developer';
import 'dart:isolate';

import 'package:visualpt/core/utils/isolate_utils.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/features/inference/service/depth_detection/depth_detection_service.dart';
import 'package:visualpt/features/inference/service/pose_classification/pose_class_service.dart';
import 'package:visualpt/features/inference/service/service_locator.dart';
import 'ai_model.dart';
import 'face_detection/face_detection_service.dart';
import 'face_mesh/face_mesh_service.dart';
import 'hands/hands_service.dart';
import 'pose_detection/pose_detection_service.dart';

class ModelInferenceService<I, O> {
  late AiModel model;
  late Function handler;

  Future<AiModelOutput?> inference({
    required String id,
    required IsolateUtils isolateUtils,
    required I input,
    required Map<String, dynamic>? params,
  }) async {
    final responsePort = ReceivePort();

    isolateUtils.sendMessage(
      handler: handler,
      params: {
        'id': id,
        'input': input,
        'detectorAddress': model.getAddress,
        'params': params,
      },
      sendPort: isolateUtils.sendPort,
      responsePort: responsePort,
    );

    final results = await responsePort.first;
    responsePort.close();
    return results;
  }

  void setModelConfig(int index) {
    switch (InferenceType.values[index]) {
      case InferenceType.faceDetection:
        log("Face Detection model configured");
        model = locator<FaceDetection>();
        handler = runFaceDetector;
        break;
      case InferenceType.faceMesh:
        log("Face Mesh model configured");
        model = locator<FaceMesh>();
        handler = runFaceMesh;
        break;
      case InferenceType.hands:
        log("Hands model configured");
        model = locator<Hands>();
        handler = runHandDetector;
        break;
      case InferenceType.poseDetection:
        log("Pose detection model configured");
        model = locator<PoseDetection>();
        handler = runPoseDetector;
        break;
      case InferenceType.poseClassification:
        log("Pose classification model configured");
        model = locator<PoseClassification>();
        handler = runPoseClassifier;
      case InferenceType.depthDetection:
        log("Pose classification model configured");
        model = locator<DepthDetection>();
        handler = runDepthDetector;
    }
  }
}
