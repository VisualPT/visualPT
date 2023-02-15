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

    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width /
            4, //TODO ensure this works well on different screens
        decoration: BoxDecoration(
          color: Styles.backgroundComplementory,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<TimerBloc, TimerState>(
              builder: (context, state) {
                if (state is TimerRunComplete) {
                  saveCameraDataToAssessment(assessmentBloc, cameraBloc);
                }
                return Text(formatter(state.duration), style: Styles.subtitle);
                //TODO this style should be the font that has even spacing
              },
            ),
          ),
        ),
      ),
    );
  }
}

String formatter(Duration duration) => [
      duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
      duration.inMilliseconds.remainder(1000).toString().padLeft(3, '0')[0]
    ].join(".");
