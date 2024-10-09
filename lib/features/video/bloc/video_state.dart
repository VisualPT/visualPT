part of 'video_bloc.dart';

@immutable
abstract class VideoState extends Equatable {
  final IconData icon;
  final Duration duration;
  final bool pauseFlag;
  const VideoState(this.icon, this.duration, [this.pauseFlag = false]);
}

class VideoLoading extends VideoState {
  const VideoLoading() : super(CupertinoIcons.hourglass, Duration.zero);

  @override
  List<Object?> get props => [];
}

class VideoRecording extends VideoState {
  final CameraController controller;
  final amplify.TemporalDateTime startTime;
  VideoRecording(
      this.controller, this.startTime, Duration duration, bool pauseFlag)
      : assert(controller.value.isInitialized),
        super(CupertinoIcons.square, duration, pauseFlag);

  @override
  List<Object?> get props => [controller, pauseFlag, duration];
}

class VideoStandby extends VideoState {
  final CameraController controller;
  const VideoStandby(this.controller, {Duration? duration})
      : super(CupertinoIcons.circle, duration ?? Duration.zero);

  @override
  List<Object?> get props => [controller];
}

class VideoPaused extends VideoState {
  final CameraController controller;
  const VideoPaused(this.controller, Duration duration)
      : super(CupertinoIcons.pause, duration);

  @override
  List<Object?> get props => [controller, duration];
}

class VideoEnded extends VideoState {
  final XFile? file;
  const VideoEnded(this.file, Duration duration)
      : super(CupertinoIcons.stop, duration);

  @override
  List<Object?> get props => [file, duration];
}

class VideoError extends VideoState {
  final Exception exception;
  const VideoError({
    required this.exception,
  }) : super(CupertinoIcons.restart, Duration.zero);

  @override
  List<Object?> get props => [exception];
}
