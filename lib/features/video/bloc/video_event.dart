part of 'video_bloc.dart';

@immutable
abstract class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object?> get props => [];
}

class VideoInit extends VideoEvent {
  //Loads the video resources
  const VideoInit();

  @override
  List<Object?> get props => [];
}

class VideoPlay extends VideoEvent {
  //Starts streaming the video data into the view and repo
  const VideoPlay();

  @override
  List<Object?> get props => [];
}

class VideoFocus extends VideoEvent {
  //Focuses and lights the frame on where the user clicks
  const VideoFocus({required this.localPosition, required this.constraints});
  final Offset localPosition;
  final BoxConstraints constraints;

  @override
  List<Object?> get props => [localPosition, constraints];
}

class VideoSwitch extends VideoEvent {
  //Switches from front to back camera
  const VideoSwitch();

  @override
  List<Object?> get props => [];
}

class VideoPause extends VideoEvent {
  //Pauses the video stream
  const VideoPause();

  @override
  List<Object?> get props => [];
}

class VideoTick extends VideoEvent {
  //Incremental time update
  const VideoTick({required this.duration});
  final Duration duration;

  @override
  List<Object?> get props => [duration];
}

class VideoStop extends VideoEvent {
  //Stops the video stream, repository and view
  final XFile? file;
  final bool reset;
  const VideoStop({required this.file, required this.reset});

  @override
  List<Object?> get props => [file, reset];
}
