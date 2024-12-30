import 'dart:developer';
import 'dart:isolate';

import 'package:visualpt/core/utils/isolate_utils.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/features/inference/service/ai_model.dart';
import 'package:visualpt/features/inference/service/depth_detection/depth_detection_service.dart';
import 'package:visualpt/features/inference/service/face_detection/face_detection_service.dart';
import 'package:visualpt/features/inference/service/face_mesh/face_mesh_service.dart';
import 'package:visualpt/features/inference/service/hands/hands_service.dart';
import 'package:visualpt/features/inference/service/pose_classification/pose_class_service.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_service.dart';

final Map<InferenceType, Map<String, dynamic>> _modelConfig = {
  InferenceType.faceDetection: {
    'model': FaceDetection(),
    'handler': runFaceDetector,
  },
  InferenceType.faceMesh: {
    'model': FaceMesh(),
    'handler': runFaceMesh,
  },
  InferenceType.hands: {
    'model': Hands(),
    'handler': runHandDetector,
  },
  InferenceType.poseDetection: {
    'model': PoseDetection(),
    'handler': runPoseDetector,
  },
  InferenceType.poseClassification: {
    'model': PoseClassification(),
    'handler': runPoseClassifier,
  },
  InferenceType.depthDetection: {
    'model': DepthDetection(),
    'handler': runDepthDetector,
  },
};

class ModelInferenceService<I, O> {
  final AiModel model;
  final Function handler;

  ModelInferenceService(InferenceType inferenceType)
      : model = _modelConfig[inferenceType]!['model'],
        handler = _modelConfig[inferenceType]!['handler'] {
    log("${inferenceType.toString().split('.').last} model configured");
  }

  Future<O?> inference({
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
      // sendPort: isolateUtils.sendPort,
      responsePort: responsePort,
    );

    final results = await responsePort.first;
    responsePort.close();
    return results;
  }

  void dispose() {
    model.dispose();
  }
}
