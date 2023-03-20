part of 'video_bloc.dart';

@immutable
abstract class VideoState {
  final IconData icon;
  final CameraController? controller;
  const VideoState(this.icon, this.controller);
}

class VideoLoading extends VideoState {
  const VideoLoading() : super(CupertinoIcons.hourglass, null);
}

class VideoRecording extends VideoState {
  const VideoRecording(CameraController controller)
      : super(CupertinoIcons.square, controller);
}

class VideoStandby extends VideoState {
  const VideoStandby(CameraController controller)
      : super(CupertinoIcons.circle, controller);
}

class VideoError extends VideoState {
  final Exception exception;
  const VideoError({
    required this.exception,
  }) : super(CupertinoIcons.restart, null);
}
