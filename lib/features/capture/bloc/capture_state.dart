part of 'capture_bloc.dart';

@immutable
abstract class CaptureState extends Equatable {
  final Duration duration;
  final bool shouldEnd;
  const CaptureState(this.duration, [this.shouldEnd = false]);
}

class CaptureDelegated extends CaptureState {
  final bool playing;
  final Detection? detection;
  const CaptureDelegated(
      {this.playing = false,
      this.detection,
      Duration duration = Duration.zero,
      bool shouldEnd = false})
      : super(duration, shouldEnd);

  @override
  List<Object?> get props => [duration, shouldEnd, playing, detection];
}

class CaptureEnded extends CaptureState {
  const CaptureEnded(super.duration);

  @override
  List<Object?> get props => [duration];
}

class CaptureError extends CaptureState {
  final Exception exception;
  const CaptureError({
    required this.exception,
  }) : super(Duration.zero);

  @override
  List<Object?> get props => [exception];
}
