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

class VideoTick extends VideoEvent {
  const VideoTick({required this.duration});
  final Duration duration;
}

class VideoRestart extends VideoEvent {
  const VideoRestart();
}

class VideoStop extends VideoEvent {
  final bool reset;
  const VideoStop({required this.reset});
}
