import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:camera/camera.dart';
import 'package:visualpt/features/inference/service/ai_model.dart';
import 'package:visualpt/features/inference/service/model_inference_service.dart';
import 'package:visualpt/features/backend/service/storage_service.dart';
import 'package:visualpt/core/utils/image_utils.dart';
import 'package:visualpt/core/utils/isolate_utils.dart';

class InferenceService {
  late IsolateUtils _poseIsolateUtils;
  late IsolateUtils _convertIsolateUtils;

  late ModelInferenceService _poseInferenceService;

  bool isInitialized = false;

  InferenceService() {
    log("Configuring Models and Isolates");
    _poseInferenceService = ModelInferenceService();
    _poseInferenceService.setModelConfig(3);
  }

  Future<void> initialize() async {
    _poseIsolateUtils = IsolateUtils();
    _convertIsolateUtils = IsolateUtils();

    await _poseIsolateUtils.initIsolate("Pose Detection Isolate");
    await _convertIsolateUtils.initIsolate("Image Conversion Isolate");
    isInitialized = true;
  }

  Future<AiModelOutput?> inference(
      {required CameraImage cameraImage,
      required Map<String, double> params}) async {
    if (!isInitialized || _poseInferenceService.model.interpreter == null) {
      return null;
    }

    await _poseInferenceService.inference(
      isolateUtils: _poseIsolateUtils,
      cameraImage: cameraImage,
      params: params,
    );
    return _poseInferenceService.inferenceResults;
  }

  void dispose() {
    _poseIsolateUtils.dispose();
    _poseInferenceService.inferenceResults = null;
  }

  void store(CameraImage input, bool classification, double ratio,
      AiModelOutput data) async {
    StorageService storageService = StorageService();
    final lines = data.output.map((line) => line.join(",")).join("\n");

    final png = await ImageUtils.convert(
      isolateUtils: _convertIsolateUtils,
      image: input,
    );

    final metadata =
        [input.height, input.width, ratio, classification ? 1 : 0].join(",");
    final detection = '$metadata\n$lines';

    final imagePayload = S3DataPayload.bytes(png, contentType: "image/png");
    final dataPayload = S3DataPayload.string(detection);

    final key = "${DateTime.now().millisecondsSinceEpoch}";
    storageService.upload(
        imagePayload, 'raw/$key.png', StorageAccessLevel.private);
    storageService.upload(
        dataPayload, 'raw/$key.csv', StorageAccessLevel.private);
  }
}
