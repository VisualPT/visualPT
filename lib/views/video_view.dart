import 'package:flutter/cupertino.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/providers/_providers.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/components/inference_preview.dart';
import 'package:visualpt/views/components/_components.dart';

class VideoView extends StatefulWidget {
  final int sequence;
  final void Function(Segment) onComplete;
  const VideoView(
      {super.key, required this.sequence, required this.onComplete});

  @override
  State<VideoView> createState() => VideoViewState();
}

class VideoViewState extends State<VideoView> with WidgetsBindingObserver {
  late BlocProviders controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(border: Border.all()),
        child: VideoProvider(
          getProviders: (context) {
            controller =
                BlocProviders(context: context, video: true, timer: true);
          },
          onComplete: widget.onComplete,
          onRecording: mainVideo,
          onStandby: mainVideo,
          //TODO add onRestart
          onLoading: loadingVideo,
          onError: errorVideo,
        ));
  }

  /// /// /// /// /// /// ///
  ///    WIDGETS BELOW    ///
  /// /// /// /// /// /// ///

  Widget mainVideo(BuildContext context, VideoState state) {
    assert(state is VideoRecording || state is VideoStandby);
    return Stack(alignment: Alignment.center, children: [
      SizedBox(
          width: MediaQuery.of(context).size.width,
          child: InferencePreview(
            cameraController: state.controller,
          )),
      Positioned(
        bottom: 0,
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Styles.backgroundAccent),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () =>
                              controller.videoBloc!.add(VideoRestart()),
                          child: const Icon(CupertinoIcons.restart,
                              color: CupertinoColors.black, size: 40)),
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                          //TODO double check the onComplete function for functionality
                          VideoTimer(),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        child: Center(
          child: GestureDetector(
            onTap: () {
              if (state is VideoRecording) {
                controller.videoBloc!.add(VideoStop());
                controller.timerBloc!.add(const TimerReset());

                //TODO only pass what is necessary
              } else {
                controller.videoBloc!.add(VideoPlay());
                controller.timerBloc!.add(const TimerStarted());
              }
            },
            child: state is VideoRecording
                ? const Icon(CupertinoIcons.stop,
                    color: Styles.backgroundComplementory, size: 80)
                : const Icon(CupertinoIcons.circle,
                    color: Styles.actionPrimary, size: 80),
          ),
        ),
      )
    ]);
  }

  Widget loadingVideo(BuildContext _, VideoState __) {
    return Center(
      child: Column(
        children: const [Text("Loading"), CupertinoActivityIndicator()],
      ),
    );
  }

  Widget errorVideo(BuildContext context, VideoState _, Exception e) {
    return Center(
      child: Column(
        children: [
          Text(e.toString()),
          CupertinoButton(
            onPressed: () => controller.videoBloc!.add(VideoRestart()),
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }
}
