part of 'capture_bloc.dart';

@immutable
abstract class CaptureEvent extends Equatable {
  const CaptureEvent(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class CapturePlay extends CaptureEvent {
  //Starts streaming the Capture data into the view and repo
  CapturePlay() : super(DateTime.now().microsecondsSinceEpoch);

  @override
  List<Object?> get props => [];
}

class CaptureTick extends CaptureEvent {
  //Incremental time update
  CaptureTick({required this.duration})
      : super(DateTime.now().microsecondsSinceEpoch);
  final Duration duration;

  @override
  List<Object?> get props => [duration];
}

class CaptureLandmark extends CaptureEvent {
  // Landmark data from the camera
  CaptureLandmark(this.landmarks, this.playing)
      : super(DateTime.now().microsecondsSinceEpoch);
  final Map<String, dynamic> landmarks;
  final bool playing;

  @override
  List<Object?> get props => [landmarks, playing];
}

class CaptureStop extends CaptureEvent {
  // Stops the Capture stream, repository and view
  CaptureStop({required this.reset})
      : super(DateTime.now().microsecondsSinceEpoch);
  final bool reset;

  @override
  List<Object?> get props => [reset];
}
