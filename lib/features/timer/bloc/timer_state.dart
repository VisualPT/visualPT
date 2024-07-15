part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  const TimerState(this.duration);
  final Duration duration;

  @override
  List<Object> get props => [duration.inMilliseconds];
}

class TimerInitial extends TimerState {
  const TimerInitial(super.duration);

  @override
  String toString() => 'TimerInitial { duration: $duration }';
}

class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(super.duration);

  @override
  List<Object> get props => [duration.inMilliseconds];

  @override
  String toString() => 'TimerRunInProgress { duration: $duration }';
}

class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(Duration.zero);

  @override
  String toString() => 'TimerRunComplete { duration: $duration }';

  @override
  List<Object> get props => [duration.inMilliseconds];
}
