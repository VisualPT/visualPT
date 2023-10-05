import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/presenter/_presenter.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/camera_painters/pose_bbox.dart';
import 'package:visualpt/views/components/_components.dart';
import 'package:visualpt/views/components/video_controls.dart';

class VideoView extends StatelessWidget {
  const VideoView(this.storageAccess, this.onComplete, {super.key});
  final bool storageAccess;
  final Function(Segment) onComplete;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ViewBackground(),
        VideoPresenter(
          storageAccess,
          onRecording: recordingVideo,
          onStandby: standbyVideo,
          onLoading: loadingVideo,
          onError: errorVideo,
        ),
      ],
    );
  }

  /// /// /// /// /// /// ///
  ///    WIDGETS BELOW    ///
  /// /// /// /// /// /// ///

  Widget recordingVideo(BuildContext context, VideoRecording state) {
    //TODO: Be more detailed about this component and try ot make it generic enough to be used by standbyVideo as well
    return VideoControls(
      onComplete: onComplete,
      state: state,
    );
  }

  Widget standbyVideo(BuildContext context, VideoStandby videoState) {
    final vid = BlocProvider.of<VideoBloc>(context),
        timer = BlocProvider.of<TimerBloc>(context),
        inf = BlocProvider.of<InferenceBloc>(context),
        screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        AspectRatio(
          aspectRatio: 1 / videoState.controller.value.aspectRatio,
          child: CameraPreview(videoState.controller, child: const PoseBbox()),
        ),
        BlocBuilder<InferenceBloc, InferenceState>(
            buildWhen: (previous, current) {
          return previous is InferenceLoading && current is InferenceStopped;
        }, builder: (context, state) {
          if (state is InferenceLoading) {
            return const AppLoading(message: "Loading Model");
          }
          return Positioned(
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  vid.add(const VideoPlay());
                  timer.add(const TimerStarted());
                  inf.add(InferenceStart(screenWidth /
                      videoState.controller.value.previewSize!.height));
                },
                child: const Icon(CupertinoIcons.circle_fill,
                    color: Styles.white, size: 80),
              ));
        }),
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
