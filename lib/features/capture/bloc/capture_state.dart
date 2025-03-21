part of 'capture_bloc.dart';

@immutable
abstract class CaptureState extends Equatable {
  const CaptureState();
}

class CaptureDelegated extends CaptureState {
  final bool playing;
  final String message;
  final int countdown;
  final int terminateTick;
  final Detection? detection;

  const CaptureDelegated({
    this.countdown = 0,
    this.message = '',
    this.playing = false,
    this.terminateTick = 0,
    this.detection,
  }) : super();

  @override
  List<Object?> get props => [playing, detection, countdown, terminateTick];
}

class CaptureEnded extends CaptureState {
  const CaptureEnded();

  @override
  List<Object?> get props => [];
}

class CaptureError extends CaptureState {
  final Exception exception;
  const CaptureError({
    required this.exception,
  }) : super();

  @override
  List<Object?> get props => [exception];
}
