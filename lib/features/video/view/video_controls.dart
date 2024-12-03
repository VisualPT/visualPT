import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/assessment/bloc/assessment_bloc.dart';
import 'package:visualpt/features/assessment/service/assessment_utils.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/video/view/capture_indicator.dart';
import 'package:visualpt/features/inference/view/pose_detection_indicator.dart';
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
        vid = BlocProvider.of<VideoBloc>(context),
        asmt = BlocProvider.of<AssessmentBloc<T>>(context);

    final vidDecRep = RepositoryProvider.of<VideoDetectionRepository>(context);

    void onComplete(VideoRecording state) {
      final index = asmt.currentCondition?.sequenceNumber ?? 0;

      detection.add(const InferenceEnd("End"));
      vid.add(const VideoStop(reset: false));
      asmt.add(AssessmentTrial(
          AssessmentUtils.formatOutput(vidDecRep.localStorage, {
            "index": index,
            "obtrustion": asmt.config.conditionObtrusion[index],
            "instability": asmt.config.conditionInstability[index]
          }),
          state.startTime,
          state.duration));
    }

    void onPause(VideoRecording state) {
      vid.add(const VideoPause());
      detection.add(const InferenceEnd("End"));

      //Show a dialog to confirm the user's next steps
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text("Trial Complete"),
              content: const Text(
                  "Would you like to continue with the next trial or review the current trial?"),
              actions: [
                CupertinoDialogAction(
                  child: const Text("Reset"),
                  onPressed: () {
                    vid.add(const VideoStop(reset: true));
                    detection.add(const InferenceEnd("End"));
                    detection.add(const InferenceInit("Start", 1));
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("Next"),
                  onPressed: () {
                    onComplete(state);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    }

    return BlocBuilder<InferenceBloc<DeviceCapture, PoseDetectionOutput>,
        InferenceState<DeviceCapture, PoseDetectionOutput>>(
      builder: (context, infState) {
        if (state.pauseFlag ||
            (state.duration >= Duration(seconds: asmt.config.trialDuration) ||
                (infState is InferenceRunning<DeviceCapture,
                        PoseDetectionOutput> &&
                    infState.response != null &&
                    asmt.config.isComplete(infState.response!)))) {
          //Check if the duration will trigger a completed capture
          onPause(state as VideoRecording);
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
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CaptureIndicator(
                            icon: CupertinoIcons.time,
                            color: Styles.black,
                            type: "Duration",
                            child: Text(formatter(state.duration),
                                style: Styles.timerTextStyle),
                          ),
                          const PoseDetectionIndicator(),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
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
                          },
                          child: const Icon(
                            CupertinoIcons.circle,
                            color: Styles.actionPrimary,
                            size: 80,
                          ),
                        )
                      ] else ...[
                        const Spacer(),
                        GestureDetector(
                          onTap: () => onPause(state as VideoRecording),
                          child: const Icon(CupertinoIcons.stop,
                              color: Styles.actionPrimary, size: 80),
                        ),
                        const Spacer(),
                      ],
                      const Spacer(),
                    ],
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
