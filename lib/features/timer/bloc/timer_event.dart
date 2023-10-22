part of 'timer_bloc.dart';

abstract class TimerEvent {
  const TimerEvent();
}

class TimerStarted extends TimerEvent {
  const TimerStarted();
}

class TimerReset extends TimerEvent {
  const TimerReset();
}

class _TimerTicked extends TimerEvent {
  const _TimerTicked({required this.duration});
  final Duration duration;
}
