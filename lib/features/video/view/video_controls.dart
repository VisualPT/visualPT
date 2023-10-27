import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/timer/bloc/timer_bloc.dart';
import 'package:visualpt/features/video/bloc/video_bloc.dart';
import 'package:visualpt/models/Segment.dart';
import 'package:visualpt/features/inference/view/inference_presenter.dart';
import 'package:visualpt/features/timer/view/timer_presenter.dart';
import 'package:visualpt/core/views/_views.dart';

class VideoControls extends StatefulWidget {
  const VideoControls(
      {super.key, required this.state, required this.onComplete});
  final VideoRecording state;
  final Function(Segment) onComplete;

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  bool classification = true;
  @override
  Widget build(BuildContext context) {
    final inf =
            BlocProvider.of<InferenceBloc<CameraImage, PoseDetectionOutput>>(
                context),
        vid = BlocProvider.of<VideoBloc>(context);

//TODO make the commands more organized
    return SafeArea(
        child: Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        InferencePresenter(videoState: widget.state),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    BlocProvider.of<VideoBloc>(context)
                        .add(const VideoRestart());
                    BlocProvider.of<TimerBloc>(context).add(const TimerReset());
                  },
                  child: const Icon(CupertinoIcons.restart,
                      color: CupertinoColors.white, size: 40)),
              const Spacer(),
              GestureDetector(
                  onTap: () {
                    inf.add(const InferenceEnd());
                    vid.add(const VideoStop());
                    widget.onComplete(Segment(
                        duration_seconds: BlocProvider.of<TimerBloc>(context)
                            .state
                            .duration
                            .inSeconds,
                        file: "TODO"));
                  },
                  child: const Icon(CupertinoIcons.stop,
                      color: Styles.backgroundComplementory, size: 80)),
              const Spacer(),
              TimerPresenter(onComplete: (durationSeconds) {
                vid.add(const VideoStop());
                widget.onComplete(
                    Segment(duration_seconds: durationSeconds, file: "TODO"));
              }),
            ],
          ),
        )
      ],
    ));
  }
}
