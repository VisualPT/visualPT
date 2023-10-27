import 'dart:math';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:camera/camera.dart';
import 'package:visualpt/core/services/repository.dart';
import 'package:visualpt/core/utils/image_utils.dart';
import 'package:visualpt/core/utils/isolate_utils.dart';
import 'package:visualpt/features/backend/service/storage_service.dart';
import 'package:visualpt/features/inference/service/model_inference_service.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';

class VideoRepository extends Repository<CameraImage, PoseDetectionOutput> {
  final ModelInferenceService _poseClassService = ModelInferenceService();
  final IsolateUtils _detectionIsolateUtils = IsolateUtils();
  final IsolateUtils _convertIsolateUtils = IsolateUtils();
  VideoRepository();

  @override
  Future<void> initialize() async {
    await _convertIsolateUtils.initIsolate("Image Conversion Isolate");
    await _detectionIsolateUtils.initIsolate("Pose Detection Isolate");
    _poseClassService.setModelConfig(3);
  }

  @override
  Future<PoseDetectionOutput> predict(
      CameraImage input, Map<String, dynamic>? params) async {
    await _poseClassService.inference(
      isolateUtils: _detectionIsolateUtils,
      input: input,
      params: params!,
    );
    return _poseClassService.inferenceResults as PoseDetectionOutput;
  }

  @override
  Future<void> store(CameraImage input, PoseDetectionOutput output,
      Map<String, dynamic>? params) async {
    StorageService storageService = StorageService();
    final lines = output.output.map((line) => line.join(",")).join("\n");

    final png = await ImageUtils.convert(
      isolateUtils: _convertIsolateUtils,
      image: input,
    );

    final metadata = [input.height, input.width, params!["ratio"], 1].join(",");
    final detection = '$metadata\n$lines';

    final imagePayload = S3DataPayload.bytes(png, contentType: "image/png");
    final dataPayload = S3DataPayload.string(detection);

//TODO: Put a user tag instead of a random number
    final key =
        "${DateTime.now().millisecondsSinceEpoch}_rand_${Random.secure().nextInt(1000)}";
    storageService.upload(
        imagePayload, 'raw/$key.png', StorageAccessLevel.private);
    storageService.upload(
        dataPayload, 'raw/$key.csv', StorageAccessLevel.private);
  }

  @override
  void dispose() {
    _convertIsolateUtils.dispose();
  }
}
