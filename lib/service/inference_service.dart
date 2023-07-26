import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:visualpt/inference/ai_model.dart';
import 'package:visualpt/inference/model_inference_service.dart';
import 'package:visualpt/utils/isolate_utils.dart';

class InferenceService {
  late IsolateUtils _poseIsolateUtils;

  late ModelInferenceService _poseInferenceService;

  bool ready = false;
  bool processing = false;

  InferenceService() {
    log("Configuring Models and Isolates");
    _poseInferenceService = ModelInferenceService();
    _poseInferenceService.setModelConfig(3);
    asyncConstructor();
  }

  void asyncConstructor() async {
    _poseIsolateUtils = IsolateUtils();

    final futures = [
      _poseIsolateUtils.initIsolate(),
    ];

    Future.wait(futures).then((value) => ready = true);
  }

  Future<AiModelOutput?> inference({required CameraImage cameraImage}) async {
    if (!ready ||
        processing ||
        _poseInferenceService.model.interpreter == null) {
      return null;
    }

    await _poseInferenceService.inference(
      isolateUtils: _poseIsolateUtils,
      cameraImage: cameraImage,
    );
    return _poseInferenceService.inferenceResults;
  }

  void dispose() {
    _poseIsolateUtils.dispose();
    _poseInferenceService.inferenceResults = null;
  }
}
