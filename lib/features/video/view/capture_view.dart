import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/inference/view/pose_detection_overlay.dart';
import 'package:visualpt/features/video/bloc/video_bloc.dart';
import 'package:visualpt/features/video/view/camera.dart';
import 'package:visualpt/features/video/view/video_presenter.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/core/views/components/_components.dart';
import 'package:visualpt/features/video/view/video_controls.dart';

class CaptureView extends StatelessWidget {
  const CaptureView(this.onComplete, {super.key});
  final Function(Segment) onComplete;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ViewBackground(),
        VideoPresenter(
          onRecording: showingVideo,
          onStandby: showingVideo,
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
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        Camera(controller: vid.controller!, children: [
          if (vid.controller != null)
            PoseDetectionOverlay(controller: vid.controller!),
          // if (vid.controller != null)
          //TODOV1   PoseClassificationOverlay(controller: vid.controller!),
        ]),
        VideoControls(state: state, onComplete: onComplete),
      ],
    ));
  }

  Widget loadingVideo(BuildContext _, VideoState __) {
    return const Center(child: AppLoading(message: "Video Stream Loading"));
  }

  Widget errorVideo(BuildContext context, VideoState state, Exception e) {
    final vid = BlocProvider.of<VideoBloc>(context);
    return Center(
      child: Column(
        children: [
          Text(e.toString()),
          CupertinoButton(
            onPressed: () => vid.add(const VideoRestart()),
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }
}
