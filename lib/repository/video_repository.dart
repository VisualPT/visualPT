import 'dart:async';
import 'package:camera/camera.dart';

class VideoRepository {
  VideoRepository();
  int frames = 0;
  final StreamController<CameraImage> _frameStreamController =
      StreamController.broadcast();

  void startRecording(CameraController controller) {
    controller.startImageStream((image) {
      frames++;
      _frameStreamController.add(image);
    });
  }

  Stream<CameraImage> get frameStream => _frameStreamController.stream;

  void dispose() {
    _frameStreamController.close();
  }
}
