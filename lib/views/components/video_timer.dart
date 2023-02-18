import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/views/_views.dart';

///Requires that a BlocProvider wrap it to function
///TODO verify how to do this without sacrificing DX
class VideoTimer extends StatelessWidget {
  const VideoTimer({super.key});

  @override
  Widget build(BuildContext context) {
    final assessmentBloc = BlocProvider.of<AssessmentBloc>(context);
    final cameraBloc = BlocProvider.of<CameraBloc>(context);

    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        if (state is TimerRunComplete) {
          saveCameraDataToAssessment(context, assessmentBloc, cameraBloc);
        }
        return Text(formatter(state.duration), style: Styles.subtitle);
        //TODO this style should be the font that has even spacing
      },
    );
  }
}
String formatter(Duration duration) => [
      duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
      duration.inMilliseconds.remainder(1000).toString().padLeft(3, '0')[0]
    ].join(".");
