part of 'video_bloc.dart';

@immutable
abstract class VideoEvent {
  const VideoEvent();
}

class VideoInit extends VideoEvent {
  const VideoInit();
}

class VideoPlay extends VideoEvent {
  const VideoPlay();
}

class VideoRestart extends VideoEvent {
  const VideoRestart();
}

class VideoStop extends VideoEvent {
  const VideoStop();
}
