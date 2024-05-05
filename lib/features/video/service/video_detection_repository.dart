import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:camera/camera.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:visualpt/core/services/repository.dart';
import 'package:visualpt/core/utils/image_utils.dart';
import 'package:visualpt/core/utils/isolate_utils.dart';
import 'package:visualpt/features/assessment/types.dart';
import 'package:visualpt/features/backend/service/storage_service.dart';
import 'package:visualpt/features/inference/service/model_inference_service.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/video/types.dart';

class VideoDetectionRepository
    extends Repository<CameraImage, PoseDetectionOutput> {
  final ModelInferenceService<TensorImage, PoseDetectionOutput>
      _poseDetectionService = ModelInferenceService();
  final IsolateUtils _detectionIsolateUtils = IsolateUtils();
  final IsolateUtils _convertIsolateUtils = IsolateUtils();
  final accelerometer = userAccelerometerEventStream();
  final gyroscope = gyroscopeEventStream();
  final String userID;
  final ClinicalMeta clinicalMeta;
  VideoDetectionRepository(this.clinicalMeta, this.userID)
      : super(clinicalMeta);

  @override
  Future<void> initialize() async {
    await _detectionIsolateUtils.initIsolate("Pose Detection Isolate");
    await _convertIsolateUtils.initIsolate("Image Conversion Isolate");
    _poseDetectionService.setModelConfig(3);
    isInitialized = true;
  }

  @override
  Future<PoseDetectionOutput?> runPredict(
      CameraImage input, Map<String, dynamic>? params) async {
    if (!isInitialized) {
      throw Exception(
          "runPredict: Detection Inference Service not initialized");
    }
    final data = preProcessData(input);
    await _poseDetectionService.inference(
      isolateUtils: _detectionIsolateUtils,
      input: data,
      params: params,
    );
    return _poseDetectionService.inferenceResults as PoseDetectionOutput?;
  }

  @override
  Future<void> store(CameraImage input, PoseDetectionOutput output,
      Map<String, dynamic>? params) async {
    if (!isInitialized) {
      throw Exception("store: Detection Inference Service not initialized");
    }
    StorageService storageService = StorageService();

    final png = await ImageUtils.convert(
      isolateUtils: _convertIsolateUtils,
      image: input,
    );

    final acc = await accelerometer.last;
    final gyro = await gyroscope.last;
    final data = VPTDetection(
            1,
            input.height,
            input.width,
            params!["ratio"],
            clinicalMeta,
            DeviceMeta(acc.x, acc.y, acc.z, gyro.x, gyro.y, gyro.z),
            "TODO", //detectionMeta.estimate,
            output)
        .toCSV();

    final imagePayload = S3DataPayload.bytes(png, contentType: "image/png");
    final dataPayload = S3DataPayload.string(data);

//TODO: Put a user tag instead of a random number
    final id = "${userID}_${DateTime.now().millisecondsSinceEpoch}";
    final key = "${meta.assessment.name}/raw/$id";
    storageService.upload(imagePayload, '$key.png', StorageAccessLevel.guest);
    storageService.upload(dataPayload, '$key.csv', StorageAccessLevel.guest);
  }

  @override
  void dispose() {
    _convertIsolateUtils.dispose();
  }
}

TensorImage preProcessData(CameraImage input) {
  final image = ImageUtils.convertCameraImage(input);

  var tensorImage = TensorImage(TfLiteType.float32);
  tensorImage.loadImage(image);
  final imageProcessor = ImageProcessorBuilder()
      .add(ResizeOp(256, 256, ResizeMethod.BILINEAR))
      .add(NormalizeOp(0, 255))
      .build();

  return imageProcessor.process(tensorImage);
}
