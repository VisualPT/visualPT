import 'dart:async';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:camera/camera.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:visualpt/core/services/repository.dart';
import 'package:visualpt/features/assessment/types.dart';
import 'package:visualpt/features/backend/service/storage_service.dart';
import 'package:visualpt/features/inference/view/pose_detection_indicator.dart';

class CaptureRepository extends Repository<DeviceCapture, DeviceCapture> {
  final accelStream = accelerometerEventStream();
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  AccelerometerEvent currentAccel = AccelerometerEvent(0, 0, 0, DateTime.now());
  final TrialMeta assessmentMeta;

  CaptureRepository(this.assessmentMeta) : super(assessmentMeta) {
    _accelSubscription = accelStream.listen((event) {
      currentAccel = event;
    });
  }

  @override
  Future<void> initialize() async {
    isInitialized = true;
  }

  @override
  Future<DeviceCapture?> runPredict(
      String id, Object input, Map<String, dynamic>? params) async {
    throw Exception(
        "runPredict: Capture Repository does not support prediction");
  }

  @override
  Future<void> store(String id, Object input, DeviceCapture output,
      Map<String, dynamic>? params) async {
    throw Exception("store: Capture Repository does not support storage");
  }

  @override
  void dispose() {
    super.dispose();
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
