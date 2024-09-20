import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/assessment/bloc/assessment_bloc.dart';
import 'package:visualpt/features/assessment/service/assessment_utils.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_classification/pose_class_output.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_classification_repository.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/inference/view/pose_classification_indicator.dart';
import 'package:visualpt/features/inference/view/pose_detection_indicator.dart';
import 'package:visualpt/features/timer/bloc/timer_bloc.dart';
import 'package:visualpt/features/video/bloc/video_bloc.dart';
import 'package:visualpt/core/views/_views.dart';
import 'package:visualpt/features/video/service/video_detection_repository.dart';

class VideoControls<T extends BaseAssessment> extends StatelessWidget {
  final VideoState state;
  final Widget videoView;
  const VideoControls(
      {super.key, required this.state, required this.videoView});

  @override
  Widget build(BuildContext context) {
    final detection =
            BlocProvider.of<InferenceBloc<DeviceCapture, PoseDetectionOutput>>(
                context),
        classification = BlocProvider.of<
                InferenceBloc<PoseDetectionOutput, PoseClassificationOutput>>(
            context),
        timer = BlocProvider.of<TimerBloc>(context),
        vid = BlocProvider.of<VideoBloc>(context),
        asmt = BlocProvider.of<AssessmentBloc<T>>(context);

    void onComplete(VideoRecording state) {
      final index = BlocProvider.of<AssessmentBloc>(context)
              .currentCondition
              ?.sequenceNumber ??
          0;
      final duration = timer.state.duration;
      detection.add(const InferenceEnd("End"));
      classification.add(const InferenceEnd("End"));
      vid.add(const VideoStop(reset: false));
      timer.add(const TimerReset());
      asmt.add(AssessmentTrial(
          AssessmentUtils.linkOutput(
              RepositoryProvider.of<VideoDetectionRepository>(context)
                  .localStorage,
              RepositoryProvider.of<DetectionClassificationRepository>(context)
                  .localStorage,
              {
                "index": index,
                "obtrustion": BlocProvider.of<AssessmentBloc>(context)
                    .config
                    .conditionObtrusion[index],
                "instability": BlocProvider.of<AssessmentBloc>(context)
                    .config
                    .conditionInstability[index]
              }),
          state.startTime,
          duration));
    }

    void onPause(VideoRecording state) {
      onComplete(state);
    }

    return BlocBuilder<InferenceBloc<DeviceCapture, PoseDetectionOutput>,
        InferenceState<DeviceCapture, PoseDetectionOutput>>(
      builder: (context, infState) {
        if (infState is InferenceRunning<DeviceCapture, PoseDetectionOutput> &&
            infState.response != null) {
          if (asmt.config.isComplete(infState.response!)) {
            onPause(state as VideoRecording);
          }
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                videoView,
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Styles.white,
                    child: const Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PoseDetectionIndicator(),
                          PoseClassificationIndicator(),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, timerState) {
                      if (timerState is TimerRunComplete) {
                        onComplete(state as VideoRecording);
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Spacer(),
                          if (infState is InferenceLoading<DeviceCapture,
                              PoseDetectionOutput>) ...[
                            const CupertinoActivityIndicator(
                              radius: 20,
                            )
                          ] else if (infState is InferenceStandby<DeviceCapture,
                                  PoseDetectionOutput> &&
                              state is VideoStandby) ...[
                            GestureDetector(
                              onTap: () {
                                final controller =
                                    (state as VideoStandby).controller;
                                //TODO: Why is the width equal to the height? This seems to be incorrect but yields the correct result
                                final params = {
                                  "height": controller.value.previewSize!.width,
                                  "width": controller.value.previewSize!.height,
                                };
                                vid.add(const VideoPlay());
                                detection.add(InferenceStart("Start", params));
                                classification
                                    .add(InferenceStart("Start", params));
                                timer.add(const TimerStarted());
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Styles.actionSecondary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.circle_fill,
                                  color: Styles.actionPrimary,
                                  size: 100,
                                ),
                              ),
                            )
                          ] else ...[
                            GestureDetector(
                              onTap: () {
                                BlocProvider.of<VideoBloc>(context)
                                    .add(const VideoStop(reset: true));
                                BlocProvider.of<TimerBloc>(context)
                                    .add(const TimerReset());
                              },
                              child: const Icon(CupertinoIcons.restart,
                                  color: Styles.white, size: 40),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => onComplete(state as VideoRecording),
                              child: const Icon(CupertinoIcons.stop,
                                  color: Styles.actionPrimary, size: 100),
                            ),
                            const Spacer(),
                            Text(formatter(timerState.duration),
                                style: Styles.timerTextStyle),
                          ],
                          const Spacer(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

String formatter(Duration duration) => [
      duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
      duration.inMilliseconds.remainder(1000).toString().padLeft(3, '0')[0]
    ].join(".");
