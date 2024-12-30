import 'dart:async';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:camera/camera.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:visualpt/core/services/repository.dart';
import 'package:visualpt/core/utils/image_utils.dart';
import 'package:visualpt/core/utils/isolate_utils.dart';
import 'package:visualpt/features/assessment/types.dart';
import 'package:visualpt/features/backend/service/storage_service.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/features/inference/service/model_inference_service.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/inference/view/pose_detection_indicator.dart';
import 'package:visualpt/features/video/types.dart';

class PoseDetectionRepository
    extends Repository<DeviceCapture, PoseDetectionOutput> {
  final ModelInferenceService<CameraImage, PoseDetectionOutput>
      _poseDetectionService =
      ModelInferenceService(InferenceType.poseDetection);
  final IsolateUtils _inferenceIsolateUtils = IsolateUtils("Inference Isolate");
  final IsolateUtils _convertIsolateUtils =
      IsolateUtils("Image Conversion Isolate");
  final accelStream = accelerometerEventStream();
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  AccelerometerEvent currentAccel = AccelerometerEvent(0, 0, 0, DateTime.now());
  final String userID;
  final TrialMeta assessmentMeta;

  PoseDetectionRepository(this.assessmentMeta, this.userID)
      : super(assessmentMeta) {
    _accelSubscription = accelStream.listen((event) {
      currentAccel = event;
    });
  }

  @override
  Future<void> initialize() async {
    isInitialized = true;
  }

  @override
  Future<PoseDetectionOutput?> runPredict(
      String id, DeviceCapture input, Map<String, dynamic>? params) async {
    if (!isInitialized) {
      throw Exception(
          "runPredict: Detection Inference Service not initialized");
    }
    final detection = await _poseDetectionService.inference(
      id: id,
      isolateUtils: _inferenceIsolateUtils,
      input: input.input,
      params: params,
    );

    //FIXME: Take the PoseDetectionOutput and DepthDetectionOutput and combine them into a single object
    // if (detection != null && depth != null) {
    //   detection.updateDepth(depth);
    // }

    if (detection != null) {
      detection.accelData = currentAccel;
      localStorage[input] = detection;
    }
    return detection;
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
        DeviceMeta(
          currentAccel.x,
          currentAccel.y,
          currentAccel.z,
        ),
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
    _accelSubscription?.cancel();
    _accelSubscription = null;
    _poseDetectionService.dispose();
    _inferenceIsolateUtils.dispose();
    _convertIsolateUtils.dispose();
    super.dispose();
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
