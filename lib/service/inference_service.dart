import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart';
import 'package:visualpt/inference/ai_model.dart';
import 'package:visualpt/inference/model_inference_service.dart';
import 'package:visualpt/inference/pose/pose_service.dart';
import 'package:visualpt/utils/image_utils.dart';
import 'package:visualpt/utils/isolate_utils.dart';

class InferenceService {
  late IsolateUtils _poseIsolateUtils;

  late ModelInferenceService _poseInferenceService;

  bool ready = false;

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
    if (!ready || _poseInferenceService.model.interpreter == null) {
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

  void store(CameraImage input, bool classification, double ratio,
      AiModelOutput data) {
    final image = ImageUtils.convertCameraImage(input);
    if (image == null) {
      throw Exception("Image is null");
    }
    final lines = data.output.map((line) => line.join(",")).join("\n");

    //TODO: process this on a separate isolate
    final png = encodePng(image);
    final metadata =
        [image.height, image.width, ratio, classification ? 1 : 0].join(",");
    final detection = '$metadata\n$lines';

    final imagePayload = S3DataPayload.bytes(png, contentType: "image/png");
    final dataPayload = S3DataPayload.string(detection);

    final key = "${DateTime.now().millisecondsSinceEpoch}";
    Amplify.Storage.uploadData(data: imagePayload, key: 'raw/$key.png');
    Amplify.Storage.uploadData(data: dataPayload, key: 'raw/$key.csv');
  }
}
