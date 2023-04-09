part of 'video_bloc.dart';

@immutable
abstract class VideoEvent {}

class VideoInit extends VideoEvent {
  final void Function(Segment) onComplete;
  VideoInit({required this.onComplete});
}

class VideoPlay extends VideoEvent {}

class VideoRestart extends VideoEvent {}

class VideoStop extends VideoEvent {}
