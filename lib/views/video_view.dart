import 'package:flutter/cupertino.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/providers/_providers.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/components/inference_preview.dart';
import 'package:visualpt/views/components/_components.dart';

class VideoView extends StatefulWidget {
  final void Function(Segment) onComplete;
  const VideoView({super.key, required this.onComplete});

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
    return VideoProvider(
      getProviders: (context) {
        controller = BlocProviders(
            context: context, video: true, timer: true, inference: true);
      },
      onComplete: widget.onComplete,
      onRecording: mainVideo,
      onStandby: mainVideo,
      onLoading: loadingVideo,
      onError: errorVideo,
    );
  }

  /// /// /// /// /// /// ///
  ///    WIDGETS BELOW    ///
  /// /// /// /// /// /// ///

  Widget mainVideo(BuildContext context, VideoState state) {
    assert(state is VideoRecording || state is VideoStandby);
    return Center(
      child:
          Stack(alignment: Alignment.center, fit: StackFit.expand, children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: InferencePreview(
            inferenceController: controller.inferenceBloc,
            cameraController: state.controller,
          ),
        ),
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          //TODO: Add functionality to the buttons
                          CupertinoButton(
                            onPressed: () {
                              print("At Risk Pressed");
                            },
                            child: const Text(
                              "At Risk",
                              style: Styles.actionText,
                            ),
                          ),
                          const Spacer(),
                          CupertinoButton(
                            onPressed: () {
                              print("No Risk Pressed");
                            },
                            child: const Text(
                              "No Risk",
                              style: Styles.actionText,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 3,
                        width: MediaQuery.of(context).size.width,
                        color: Styles.backgroundPrimary,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          state is VideoRecording
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                      onTap: () => controller.videoBloc!
                                          .add(VideoRestart()),
                                      child: const Icon(CupertinoIcons.restart,
                                          color: CupertinoColors.black,
                                          size: 40)),
                                )
                              : const SizedBox(),
                          const Spacer(),
                          const SafeArea(
                            child:
                                //TODO double check the onComplete function for functionality
                                VideoTimer(),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
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
                }
                if (state is VideoStandby) {
                  controller.videoBloc!.add(VideoPlay());
                  controller.timerBloc!.add(const TimerStarted());
                }
              },
              child: state is VideoRecording
                  ? const Icon(CupertinoIcons.stop,
                      color: Styles.backgroundComplementory, size: 80)
                  : const Icon(CupertinoIcons.circle_fill,
                      color: Styles.actionPrimary, size: 80),
            ),
          ),
        )
      ]),
    );
  }

  Widget loadingVideo(BuildContext _, VideoState __) {
    return const Center(child: AppLoading(message: "Loading Camera"));
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
