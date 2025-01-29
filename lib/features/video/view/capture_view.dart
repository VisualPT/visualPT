import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/assessment/bloc/assessment_bloc.dart';
import 'package:visualpt/features/assessment/service/assessment_utils.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_repository.dart';
import 'package:visualpt/features/inference/view/pose_detection_indicator.dart';
import 'package:visualpt/features/inference/view/pose_detection_overlay.dart';
import 'package:visualpt/features/video/bloc/video_bloc.dart';
import 'package:visualpt/features/video/view/camera.dart';
import 'package:visualpt/features/video/view/video_presenter.dart';
import 'package:visualpt/core/views/components/_components.dart';
import 'package:visualpt/features/video/view/video_controls.dart';

class CaptureView<T extends BaseAssessment> extends StatelessWidget {
  final AssessmentActive<T> state;
  const CaptureView(this.state, {super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoPresenter(
          key: UniqueKey(),
          state.storeData,
          state.trialMeta,
          state.meta.conditions,
          state.meta.trialDuration,
          onRecording: showingVideo,
          onStandby: showingVideo,
          onPaused: pausedVideo,
          onEnded: endedVideo,
          onLoading: loadingVideo,
          onError: errorVideo,
        ),
      ],
    );
  }

  /// /// /// /// /// /// ///
  ///    WIDGETS BELOW    ///
  /// /// /// /// /// /// ///

  Widget showingVideo(BuildContext context, VideoState state) {
    final vid = BlocProvider.of<VideoBloc>(context);
    return SafeArea(
        child: Stack(
      alignment: Alignment.topCenter,
      children: [
        vid.controller != null
            ? VideoControls<T>(
                state: state,
                videoView: Camera(controller: vid.controller!, children: [
                  if (vid.controller != null)
                    PoseDetectionOverlay(controller: vid.controller!),
                ]))
            : Container(),
      ],
    ));
  }

  Widget pausedVideo(BuildContext context, VideoPaused state) {
    final detection =
            BlocProvider.of<InferenceBloc<DeviceCapture, PoseDetectionOutput>>(
                context),
        vid = BlocProvider.of<VideoBloc>(context),
        asmt = BlocProvider.of<AssessmentBloc<T>>(context),
        poseRep = RepositoryProvider.of<PoseDetectionRepository>(context);

    void onReset() {
      // End video, end inference, re-init
      vid.add(VideoStop(file: state.file, reset: true));
      detection.add(const InferenceInit("Start", 1));
    }

    void onComplete() {
      // Mark the trial as complete, store results
      final index = asmt.currentCondition?.sequenceNumber ?? 0;
      vid.add(VideoStop(file: state.file, reset: false));

      asmt.add(
        AssessmentTrial(
          AssessmentUtils.formatOutput(
            poseRep.localStorage,
            {
              "index": index,
              "obtrustion": asmt.config.conditionObtrusion[index],
              "instability": asmt.config.conditionInstability[index],
            },
          ),
          state.startTime,
          state.duration,
        ),
      );
    }

    return SafeArea(
      child: Container(
        color: CupertinoColors.systemBackground, // or any other background
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Video Paused",
              style: CupertinoTheme.of(context)
                  .textTheme
                  .navTitleTextStyle
                  .copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Would you like to reset this trial or proceed to the next?",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Reset
                CupertinoButton(
                  onPressed: onReset,
                  child: const Text("Reset"),
                ),
                // Next
                CupertinoButton(
                  onPressed: onComplete,
                  child: const Text("Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingVideo(BuildContext _, VideoState __) {
    return const Center(child: AppLoading(message: "Video Stream Loading"));
  }

  Widget endedVideo(BuildContext context, VideoEnded state) {
    final vid = BlocProvider.of<VideoBloc>(context);
    return Center(
      child: Column(
        children: [
          const Text("Video Stopped"),
          CupertinoButton(
            onPressed: () => vid.add(const VideoInit()),
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }

  Widget errorVideo(BuildContext context, VideoState state, Exception e) {
    final vid = BlocProvider.of<VideoBloc>(context);
    return Center(
      child: Column(
        children: [
          Text(e.toString()),
          CupertinoButton(
            onPressed: () => vid.add(const VideoStop(file: null, reset: true)),
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }
}
