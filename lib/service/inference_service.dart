import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:visualpt/inference/model_inference_service.dart';
import 'package:visualpt/utils/isolate_utils.dart';

class InferenceService {
  late IsolateUtils _faceIsolateUtils;
  late IsolateUtils _handIsolateUtils;
  late IsolateUtils _poseIsolateUtils;

  late ModelInferenceService _faceInferenceService;
  late ModelInferenceService _handInferenceService;
  late ModelInferenceService _poseInferenceService;

  late Map<String, dynamic>? aggregatedResponse;

  bool ready = false;
  bool processing = false;

  InferenceService() {
    log("Configuring Models and Isolates");
    _faceInferenceService = ModelInferenceService();
    _handInferenceService = ModelInferenceService();
    _poseInferenceService = ModelInferenceService();

    _faceInferenceService.setModelConfig(1);
    _handInferenceService.setModelConfig(2);
    _poseInferenceService.setModelConfig(3);

    aggregatedResponse = {};
    asyncConstructor();
  }

  void asyncConstructor() async {
    _faceIsolateUtils = IsolateUtils();
    _handIsolateUtils = IsolateUtils();
    _poseIsolateUtils = IsolateUtils();

    final futures = [
      _faceIsolateUtils.initIsolate(),
      _handIsolateUtils.initIsolate(),
      _poseIsolateUtils.initIsolate(),
    ];

    Future.wait(futures).then((value) => ready = true);
  }

  Future<void> inference({required CameraImage cameraImage}) async {
    processing = true;
    if (_faceInferenceService.model.interpreter != null &&
        _handInferenceService.model.interpreter != null &&
        _poseInferenceService.model.interpreter != null) {
      await _faceInferenceService.inference(
        isolateUtils: _faceIsolateUtils,
        cameraImage: cameraImage,
      );
      await _handInferenceService.inference(
        isolateUtils: _handIsolateUtils,
        cameraImage: cameraImage,
      );
      await _poseInferenceService.inference(
        isolateUtils: _poseIsolateUtils,
        cameraImage: cameraImage,
      );
      print(aggregatedResponse);
      aggregatedResponse!.clear();
      aggregatedResponse!
          .addAll(_faceInferenceService.inferenceResults ?? {"face": null});
      aggregatedResponse!
          .addAll(_handInferenceService.inferenceResults ?? {"hand": null});
      aggregatedResponse!
          .addAll(_poseInferenceService.inferenceResults ?? {"pose": null});
      processing = false;
    }
  }

  void dispose() {
    _faceIsolateUtils.dispose();
    _handIsolateUtils.dispose();
    _poseIsolateUtils.dispose();

    _faceInferenceService.inferenceResults = null;
    _handInferenceService.inferenceResults = null;
    _poseInferenceService.inferenceResults = null;
  }
}
