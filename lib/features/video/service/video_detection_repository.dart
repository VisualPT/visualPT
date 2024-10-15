import 'dart:async';

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
  final accelStream = userAccelerometerEventStream();
  final gyroStream = gyroscopeEventStream();
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;
  StreamSubscription<UserAccelerometerEvent>? _accelSubscription;
  GyroscopeEvent currentGyro = GyroscopeEvent(0, 0, 0, DateTime.now());
  UserAccelerometerEvent currentAccel =
      UserAccelerometerEvent(0, 0, 0, DateTime.now());
  final String userID;
  final TrialMeta assessmentMeta;

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
    _poseDetectionService.setModelConfig(3);
    isInitialized = true;
  }

  @override
  Future<PoseDetectionOutput?> runPredict(Map<String, dynamic> params) async {
    if (!isInitialized) {
      throw Exception(
          "runPredict: Detection Inference Service not initialized");
    }
    final id = params['id'] as String;
    final input = params['input'] as DeviceCapture;
    final data = preProcessData(input.input);
    final newParams = {
      'id': id,
      'input': data,
      'params': params['params'],
    };
    final output = await _poseDetectionService.inference(
      isolateUtils: _detectionIsolateUtils,
      params: newParams,
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
      // isolateUtils: _convertIsolateUtils,
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

    final idPath = "${userID}_$id";
    final key = "${meta.assessment.name}/raw/$idPath";
    storageService.upload(imagePayload, 'public/$key.png');
    storageService.upload(dataPayload, 'public/$key.csv');
  }

  @override
  void dispose() {
    _detectionIsolateUtils.dispose();
    _gyroSubscription?.cancel();
    _accelSubscription?.cancel();
  }

  Future<void> saveVideo(String id, XFile file) async {
    final storageService = StorageService();
    final key = "${assessmentMeta.assessment.name}/video/$id.mp4";
    final fileBytes = await file.readAsBytes();
    final videoPayload =
        S3DataPayload.bytes(fileBytes, contentType: "video/mp4");
    storageService.upload(videoPayload, 'public/$key');
  }
}

//TODO: FIGURE OUT WHY THIS SHIT IS BROKEN
TensorImage preProcessData(CameraImage input) {
  final image = ImageUtils.convertCameraImage(input);

  var tensorImage = TensorImage(TensorType.float32);
  tensorImage.loadImage(image);

  // final imageProcessor = ImageProcessorBuilder()
  //     .add(ResizeOp(256, 256, ResizeMethod.BILINEAR))
  //     .add(NormalizeOp(0, 255))
  //     .build();

  // final output = imageProcessor.process(tensorImage);

  return tensorImage;
}
