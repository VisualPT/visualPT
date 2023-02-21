part of 'camera_bloc.dart';

@immutable
abstract class CameraState {
  final IconData icon;
  final CameraController? controller;
  const CameraState(this.icon, this.controller);
}

class CameraLoading extends CameraState {
  const CameraLoading() : super(CupertinoIcons.hourglass, null);
}

class CameraRecording extends CameraState {
  const CameraRecording(CameraController controller)
      : super(CupertinoIcons.square, controller);
}

class CameraStandby extends CameraState {
  const CameraStandby(CameraController controller)
      : super(CupertinoIcons.circle, controller);
}

class CameraError extends CameraState {
  final Exception exception;
  const CameraError({required this.exception})
      : super(CupertinoIcons.restart, null);
}
