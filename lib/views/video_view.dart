import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/providers/_providers.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/components/inference_painter.dart';
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

  Widget mainVideo(BuildContext context, VideoState videoState) {
    assert(videoState is VideoRecording || videoState is VideoStandby);
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, timerState) {
        if (timerState is TimerRunComplete) {
          BlocProvider.of<VideoBloc>(context)
              .add(VideoStop(videoState.controller!));
        }
        return Center(
          child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: InferencePainter(
                      inferenceController: controller.inferenceBloc,
                      timerController: controller.timerBloc,
                      videoState: videoState),
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
                              Container(
                                height: 3,
                                width: MediaQuery.of(context).size.width,
                                color: Styles.backgroundPrimary,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  videoState is VideoRecording
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                controller.videoBloc!.add(
                                                    VideoRestart(videoState
                                                        .controller!));
                                                controller.timerBloc!
                                                    .add(const TimerReset());
                                                controller.timerBloc!
                                                    .add(const TimerStarted());
                                              },
                                              child: const Icon(
                                                  CupertinoIcons.restart,
                                                  color: CupertinoColors.black,
                                                  size: 40)),
                                        )
                                      : const SizedBox(),
                                  const Spacer(),
                                  SafeArea(
                                    child: VideoTimer(
                                        cameraController:
                                            videoState.controller!,
                                        duration: timerState.duration),
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
                BlocBuilder<InferenceBloc, InferenceState>(
                    builder: (context, state) {
                  if (state.ready) {
                    return Positioned(
                      bottom: 20,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            if (videoState is VideoRecording) {
                              controller.inferenceBloc!
                                  .add(const InferenceEnd());
                              controller.timerBloc!.add(const TimerReset());
                              controller.videoBloc!
                                  .add(VideoStop(videoState.controller!));
                            }
                            if (videoState is VideoStandby) {
                              controller.videoBloc!
                                  .add(VideoPlay(videoState.controller!));
                              controller.timerBloc!.add(const TimerStarted());
                            }
                          },
                          child: videoState is VideoRecording
                              ? const Icon(CupertinoIcons.stop,
                                  color: Styles.backgroundComplementory,
                                  size: 80)
                              : const Icon(CupertinoIcons.circle_fill,
                                  color: Styles.actionPrimary, size: 80),
                        ),
                      ),
                    );
                  }
                  return Container();
                })
              ]),
        );
      },
    );
  }

  Widget loadingVideo(BuildContext _, VideoState __) {
    return const Center(child: AppLoading(message: "Loading Camera"));
  }

  Widget errorVideo(BuildContext context, VideoState state, Exception e) {
    return Center(
      child: Column(
        children: [
          Text(e.toString()),
          CupertinoButton(
            onPressed: () => state.controller != null
                ? controller.videoBloc!.add(VideoRestart(state.controller!))
                : controller.videoBloc!
                    .add(VideoInit(onComplete: widget.onComplete)),
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }
}
