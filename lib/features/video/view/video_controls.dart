import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/inference/view/pose_detection_indicator.dart';
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
    final detection =
            BlocProvider.of<InferenceBloc<CameraImage, PoseDetectionOutput>>(
                context),
        //TODOV1 classification = BlocProvider.of<InferenceBloc<PoseDetectionOutput, PoseClassificationOutput>>(context),
        timer = BlocProvider.of<TimerBloc>(context),
        screenW = MediaQuery.of(context).size.width,
        vid = BlocProvider.of<VideoBloc>(context);

//TODO: Make the video controls show up when ALL the models are ready
    return BlocBuilder<InferenceBloc<CameraImage, PoseDetectionOutput>,
        InferenceState>(builder: (context, infState) {
      if (infState is InferenceRunning && infState.response != null) {}
      return Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Takes the least amount of space
              children: [
                Container(
                  color: CupertinoColors.white,
                  child: const Padding(
                    padding: EdgeInsets.all(2.0), // Add padding as needed
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize:
                              MainAxisSize.min, // Fit content in the column
                          children: [
                            PoseDetectionIndicator(),
                            //TODOV1 PoseClassificationIndicator(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                if (infState is InferenceLoading) ...[
                  const CupertinoActivityIndicator(
                    radius: 20,
                  )
                ] else if (infState is InferenceStandby &&
                    state is VideoStandby) ...[
                  GestureDetector(
                    onTap: () {
                      final controller = (state as VideoStandby).controller;
                      final params = {
                        "ratio": screenW / controller.value.previewSize!.height,
                        "width": controller.value.previewSize!.height,
                        "height": controller.value.previewSize!.width,
                      };
                      vid.add(const VideoPlay());
                      timer.add(const TimerStarted());
                      detection.add(InferenceStart(params));
                      //TODOV1 classification.add(InferenceStart(store: store));
                    },
                    child: const Icon(CupertinoIcons.circle_fill,
                        color: Styles.white, size: 80),
                  )
                ] else ...[
                  GestureDetector(
                      onTap: () {
                        BlocProvider.of<VideoBloc>(context)
                            .add(const VideoRestart());
                        BlocProvider.of<TimerBloc>(context)
                            .add(const TimerReset());
                      },
                      child: const Icon(CupertinoIcons.restart,
                          color: CupertinoColors.white, size: 40)),
                  const Spacer(),
                  GestureDetector(
                      onTap: () {
                        detection.add(const InferenceEnd());
                        //TODOV1classification.add(const InferenceEnd());
                        vid.add(const VideoStop());
                        onComplete(Segment(
                            duration_seconds:
                                BlocProvider.of<TimerBloc>(context)
                                    .state
                                    .duration
                                    .inSeconds,
                            file: "TODO"));
                        timer.add(const TimerReset());
                        vid.add(const VideoInit());
                      },
                      child: const Icon(CupertinoIcons.stop,
                          color: Styles.backgroundComplementory, size: 80)),
                  const Spacer(),
                  TimerPresenter(onComplete: (durationSeconds) {
                    detection.add(const InferenceEnd());
                    vid.add(const VideoStop());
                    onComplete(Segment(
                        duration_seconds: durationSeconds, file: "TODO"));
                    vid.add(const VideoInit());
                  }),
                ],
                const Spacer(),
              ],
            ),
          ),
        ],
      );
    });
  }
}
