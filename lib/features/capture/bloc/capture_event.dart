part of 'capture_bloc.dart';

@immutable
abstract class CaptureEvent extends Equatable {
  const CaptureEvent(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class CaptureMessage extends CaptureEvent {
  //Message from the Kinestex SDK
  CaptureMessage(this.message, this.playing)
      : super(DateTime.now().microsecondsSinceEpoch);
  final WebViewMessage message;
  final bool playing;

  @override
  List<Object?> get props => [message, playing];
}

class CapturePlay extends CaptureEvent {
  //Starts streaming the Capture data into the view and repo
  CapturePlay() : super(DateTime.now().microsecondsSinceEpoch);

  @override
  List<Object?> get props => [];
}

class CaptureToggle extends CaptureEvent {
  //Toggles the camera direction
  CaptureToggle(this.direction) : super(DateTime.now().microsecondsSinceEpoch);
  final CameraDirection direction;

  @override
  List<Object?> get props => [direction];
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

class CaptureWarn extends CaptureEvent {
  // Warning from the camera
  CaptureWarn(this.warning, {this.decay = 1})
      : super(DateTime.now().microsecondsSinceEpoch);
  final String warning;
  final int decay; // controls decay rate

  @override
  List<Object?> get props => [warning, decay];
}

class CapturePause extends CaptureEvent {
  // Pauses the Capture stream, repository and view
  CapturePause() : super(DateTime.now().microsecondsSinceEpoch);

  @override
  List<Object?> get props => [];
}

class CaptureStop extends CaptureEvent {
  // Stops the Capture stream, repository and view
  CaptureStop({required this.reset})
      : super(DateTime.now().microsecondsSinceEpoch);
  final bool reset;

  @override
  List<Object?> get props => [reset];
}
