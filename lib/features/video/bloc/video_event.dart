part of 'video_bloc.dart';

@immutable
abstract class VideoEvent {
  const VideoEvent();
}

class VideoInit extends VideoEvent {
  //Loads the video resources
  const VideoInit();
}

class VideoPlay extends VideoEvent {
  //Starts streaming the video data into the view and repo
  const VideoPlay();
}

class VideoPause extends VideoEvent {
  //Pauses the video stream
  const VideoPause();
}

class VideoTick extends VideoEvent {
  //Incremental time update
  const VideoTick({required this.duration});
  final Duration duration;
}

class VideoStop extends VideoEvent {
  //Stops the video stream, repository and view
  final XFile? file;
  final bool reset;
  const VideoStop({required this.file, required this.reset});
}
