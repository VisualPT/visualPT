import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_classification/pose_class_output.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/timer/bloc/timer_bloc.dart';
import 'package:visualpt/features/video/bloc/video_bloc.dart';
import 'package:visualpt/models/Segment.dart';
import 'package:visualpt/features/timer/view/timer_presenter.dart';
import 'package:visualpt/core/views/_views.dart';

class VideoControls extends StatelessWidget {
  const VideoControls(
      {super.key, required this.state, required this.onComplete});
  final VideoState state;
  final Function(Segment) onComplete;

  @override
  Widget build(BuildContext context) {
    final tempState = state;
    final detection =
            BlocProvider.of<InferenceBloc<CameraImage, PoseDetectionOutput>>(
                context),
        classification = BlocProvider.of<
                InferenceBloc<PoseDetectionOutput, PoseClassificationOutput>>(
            context),
        timer = BlocProvider.of<TimerBloc>(context),
        screenWidth = MediaQuery.of(context).size.width,
        vid = BlocProvider.of<VideoBloc>(context);

//TODO: Make the video controls show up when ALL the models are ready
    return BlocBuilder<InferenceBloc<CameraImage, PoseDetectionOutput>,
        InferenceState>(builder: (context, infState) {
      if (infState is InferenceLoading) {
        return Container();
      } else if (infState is InferenceStopped && tempState is VideoStandby) {
        return Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                vid.add(const VideoPlay());
                timer.add(const TimerStarted());
                detection.add(InferenceStart({
                  "ratio": screenWidth /
                      tempState.controller.value.previewSize!.height
                }));
              },
              child: const Icon(CupertinoIcons.circle_fill,
                  color: Styles.white, size: 80),
            ));
      } else {
        return Positioned(
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
                    detection.add(const InferenceEnd());
                    classification.add(const InferenceEnd());
                    vid.add(const VideoStop());
                    onComplete(Segment(
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
                onComplete(
                    Segment(duration_seconds: durationSeconds, file: "TODO"));
              }),
            ],
          ),
        );
      }
    });
  }
}
