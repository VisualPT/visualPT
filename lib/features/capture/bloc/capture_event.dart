part of 'capture_bloc.dart';

@immutable
abstract class CaptureEvent extends Equatable {
  const CaptureEvent();

  @override
  List<Object?> get props => [];
}

class CapturePlay extends CaptureEvent {
  //Starts streaming the Capture data into the view and repo
  const CapturePlay();

  @override
  List<Object?> get props => [];
}

class CaptureTick extends CaptureEvent {
  //Incremental time update
  const CaptureTick({required this.duration});
  final Duration duration;

  @override
  List<Object?> get props => [duration];
}

class CaptureLandmark extends CaptureEvent {
  //Landmark data from the camera
  const CaptureLandmark(this.landmarks);
  final Map<String, dynamic> landmarks;

  @override
  List<Object?> get props => [landmarks];
}

class CaptureStop extends CaptureEvent {
  //Stops the Capture stream, repository and view
  final bool reset;
  const CaptureStop({required this.reset});

  @override
  List<Object?> get props => [reset];
}
