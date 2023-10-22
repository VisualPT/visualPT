import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/timer/bloc/timer_bloc.dart';
import 'package:visualpt/core/views/_views.dart';

class TimerPresenter extends StatelessWidget {
  final Function(int) onComplete;
  const TimerPresenter({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        if (state is TimerRunComplete) {
          onComplete(state.duration.inSeconds);
        }
        return Text(formatter(state.duration), style: Styles.timerTextStyle);
      },
    );
  }
}

String formatter(Duration duration) => [
      duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
      duration.inMilliseconds.remainder(1000).toString().padLeft(3, '0')[0]
    ].join(".");
