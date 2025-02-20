import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:visualpt/core/services/repository.dart';
import 'package:visualpt/models/ModelProvider.dart';

class CaptureRepository extends Repository<DetectionEnv, Detection> {
  final accelStream = accelerometerEventStream();
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  AccelerometerEvent currentAccel = AccelerometerEvent(0, 0, 0, DateTime.now());
  final bool storeData;

  CaptureRepository(this.storeData) : super() {
    _accelSubscription = accelStream.listen((event) {
      currentAccel = event;
    });
  }

  @override
  Future<void> initialize() async {
    isInitialized = true;
  }

  @override
  Future<void> store(String id, DetectionEnv input, Detection output,
      Map<String, dynamic>? params) async {
    if (!isInitialized) {
      throw Exception("store: Detection Inference Service not initialized");
    }

    //FIXME: Store this in Amplify and pull the video from KinteseX to S3
  }

  @override
  void dispose() {
    _accelSubscription?.cancel();
    _accelSubscription = null;
    super.dispose();
  }

//TODO: Implement this with KinesteX
  // Future<void> saveVideo(String id, XFile file) async {
  //   final storageService = StorageService();
  //   final key = "${assessmentMeta.assessment.name}/video/$id.mp4";
  //   final fileBytes = await file.readAsBytes();
  //   final videoPayload =
  //       S3DataPayload.bytes(fileBytes, contentType: "video/mp4");
  //   storageService.upload(videoPayload, 'public/$key');
  // }
}
