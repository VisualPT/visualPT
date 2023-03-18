part of 'video_bloc.dart';

@immutable
abstract class CameraEvent {}

class CameraInit extends CameraEvent {
  final void Function(VideoOutput) onComplete;
  CameraInit({required this.onComplete});
}

class CameraPlay extends CameraEvent {}

class CameraRestart extends CameraEvent {}

class CameraStop extends CameraEvent {}
