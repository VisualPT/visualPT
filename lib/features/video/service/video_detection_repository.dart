import 'dart:async';

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
import 'package:visualpt/features/inference/view/pose_detection_indicator.dart';
import 'package:visualpt/features/video/types.dart';

class VideoDetectionRepository
    extends Repository<DeviceCapture, PoseDetectionOutput> {
  final ModelInferenceService<TensorImage, PoseDetectionOutput>
      _poseDetectionService = ModelInferenceService();
  final IsolateUtils _detectionIsolateUtils = IsolateUtils();
  final IsolateUtils _convertIsolateUtils = IsolateUtils();
  final accelStream = userAccelerometerEventStream();
  final gyroStream = gyroscopeEventStream();
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;
  StreamSubscription<UserAccelerometerEvent>? _accelSubscription;
  GyroscopeEvent currentGyro = GyroscopeEvent(0, 0, 0);
  UserAccelerometerEvent currentAccel = UserAccelerometerEvent(0, 0, 0);
  final String userID;
  final AssessmentMeta assessmentMeta;
  final List<VPTDetection> detectionBucket = [];

  VideoDetectionRepository(this.assessmentMeta, this.userID)
      : super(assessmentMeta) {
    _gyroSubscription = gyroStream.listen((gyroData) {
      currentGyro = gyroData;
    });

    _accelSubscription = accelStream.listen((accelData) {
      currentAccel = accelData;
    });
  }

  @override
  Future<void> initialize() async {
    await _detectionIsolateUtils.initIsolate("Pose Detection Isolate");
    await _convertIsolateUtils.initIsolate("Image Conversion Isolate");
    _poseDetectionService.setModelConfig(3);
    isInitialized = true;
  }

  @override
  Future<PoseDetectionOutput?> runPredict(
      String id, DeviceCapture input, Map<String, dynamic>? params) async {
    if (!isInitialized) {
      throw Exception(
          "runPredict: Detection Inference Service not initialized");
    }
    final data = preProcessData(input.input);
    final output = await _poseDetectionService.inference(
      id: id,
      isolateUtils: _detectionIsolateUtils,
      input: data,
      params: params,
    ) as PoseDetectionOutput?;
    if (output != null) localStorage[input] = output;
    return output;
  }

  @override
  Future<void> store(String id, DeviceCapture input, PoseDetectionOutput output,
      Map<String, dynamic>? params) async {
    if (!isInitialized) {
      throw Exception("store: Detection Inference Service not initialized");
    }
    StorageService storageService = StorageService();

    final png = await ImageUtils.convert(
      isolateUtils: _convertIsolateUtils,
      image: input.input,
    );
    final data = VPTDetection(
        1,
        id,
        input.input.height,
        input.input.width,
        assessmentMeta,
        DeviceMeta(currentAccel.x, currentAccel.y, currentAccel.z,
            currentGyro.x, currentGyro.y, currentGyro.z),
        "-1", //detectionMeta.estimate,
        output);

    final imagePayload = S3DataPayload.bytes(png, contentType: "image/png");
    final dataPayload = S3DataPayload.string(data.toCSV());

//TODO: Put a user tag instead of a random number
    final idPath = "${userID}_$id";
    final key = "${meta.assessment.name}/raw/$idPath";
    storageService.upload(imagePayload, '$key.png', StorageAccessLevel.guest);
    storageService.upload(dataPayload, '$key.csv', StorageAccessLevel.guest);
  }

  @override
  void dispose() {
    _detectionIsolateUtils.dispose();
    _convertIsolateUtils.dispose();
    _gyroSubscription?.cancel();
    _accelSubscription?.cancel();
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
