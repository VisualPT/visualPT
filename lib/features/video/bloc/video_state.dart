part of 'video_bloc.dart';

@immutable
abstract class VideoState extends Equatable {
  final IconData icon;
  const VideoState(this.icon);
}

class VideoLoading extends VideoState {
  const VideoLoading() : super(CupertinoIcons.hourglass);

  @override
  List<Object?> get props => [];
}

class VideoRecording extends VideoState {
  final CameraController controller;
  final amplify.TemporalDateTime startTime;
  VideoRecording(this.controller, this.startTime)
      : assert(controller.value.isInitialized),
        super(CupertinoIcons.square);

  @override
  List<Object?> get props => [controller];
}

class VideoStandby extends VideoState {
  final CameraController controller;
  const VideoStandby(this.controller) : super(CupertinoIcons.circle);

  @override
  List<Object?> get props => [controller];
}

class VideoStopped extends VideoState {
  final XFile? file;
  final Duration videoDuration;
  const VideoStopped(this.file, this.videoDuration)
      : super(CupertinoIcons.stop);

  @override
  List<Object?> get props => [file, videoDuration];
}

class VideoError extends VideoState {
  final Exception exception;
  const VideoError({
    required this.exception,
  }) : super(CupertinoIcons.restart);

  @override
  List<Object?> get props => [exception];
}
