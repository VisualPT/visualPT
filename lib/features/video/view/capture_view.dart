import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/assessment/bloc/assessment_bloc.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/inference/view/pose_detection_overlay.dart';
import 'package:visualpt/features/video/bloc/video_bloc.dart';
import 'package:visualpt/features/video/view/camera.dart';
import 'package:visualpt/features/video/view/video_presenter.dart';
import 'package:visualpt/core/views/components/_components.dart';
import 'package:visualpt/features/video/view/video_controls.dart';

//TODO: Everything within this widget should be rebuilt on the native side
class CaptureView<T extends BaseAssessment> extends StatelessWidget {
  final AssessmentActive<T> state;
  const CaptureView(this.state, {super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ViewBackground(),
        VideoPresenter(
          key: UniqueKey(),
          state.meta,
          state.assessment.conditions,
          state.assessment.trialDuration,
          onRecording: showingVideo,
          onStandby: showingVideo,
          onStopped: stoppedVideo,
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

    //TODO: Be more detailed about this component and try ot make it generic enough to be used by standbyVideo as well
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

  Widget loadingVideo(BuildContext _, VideoState __) {
    return const Center(child: AppLoading(message: "Video Stream Loading"));
  }

  Widget stoppedVideo(BuildContext context, VideoStopped state) {
    final vid = BlocProvider.of<VideoBloc>(context);
    return Center(
      child: Column(
        children: [
          const Text("Video Stopped"),
          CupertinoButton(
            onPressed: () => vid.add(const VideoPlay()),
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
            onPressed: () => vid.add(const VideoStop(reset: true)),
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }
}
