///Sourced from https://github.com/felangel/bloc/tree/master/examples/flutter_timer

import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'timer_event.dart';
part 'timer_state.dart';

//TODO This could change depending on the test, may need to specify this when creating the bloc in the future
const Duration _minDuration = Duration(seconds: 0);
const Duration _maxDuration = Duration(seconds: 30);

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc()
      : _ticker = const Ticker(),
        super(const TimerInitial(_minDuration)) {
    on<TimerStarted>(_onStarted);
    on<TimerReset>(_onReset);
    on<_TimerTicked>(_onTicked, transformer: droppable());
  }

  final Ticker _ticker;
  StreamSubscription<Duration>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(const TimerRunInProgress(Duration(milliseconds: 0)));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick()
        .listen((duration) => add(_TimerTicked(duration: duration)));
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const TimerInitial(_minDuration));
  }

  void _onTicked(_TimerTicked event, Emitter<TimerState> emit) {
    emit(
      event.duration < _maxDuration
          ? TimerRunInProgress(event.duration)
          : const TimerRunComplete(),
    );
  }
}

//Stream class that powers the entire BLOC
class Ticker {
  static const increment = 10;
  const Ticker();
  Stream<Duration> tick() {
    return Stream.periodic(
      const Duration(milliseconds: increment),
      (x) => Duration(milliseconds: increment * x),
    ).takeWhile(
      (duration) => duration <= _maxDuration,
    );
  }
}
