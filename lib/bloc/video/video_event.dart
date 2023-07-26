part of 'video_bloc.dart';

@immutable
abstract class VideoEvent {}

class VideoInit extends VideoEvent {
  final void Function(Segment) onComplete;
  VideoInit({required this.onComplete});
}

class VideoPlay extends VideoEvent {
  final CameraController controller;
  VideoPlay(this.controller);
}

class VideoRestart extends VideoEvent {
  final CameraController controller;
  VideoRestart(this.controller);
}

class VideoStop extends VideoEvent {
  final CameraController controller;
  VideoStop(this.controller);
}
