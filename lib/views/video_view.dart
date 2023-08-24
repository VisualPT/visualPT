import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/presenter/_presenter.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/presenter/inference_presenter.dart';
import 'package:visualpt/views/components/_components.dart';

class VideoView extends StatelessWidget {
  final Function(Segment) onComplete;
  const VideoView({required this.onComplete, super.key});

  @override
  Widget build(BuildContext context) {
    return VideoPresenter(
      onRecording: recordingVideo,
      onStandby: standbyVideo,
      onLoading: loadingVideo,
      onError: errorVideo,
    );
  }

  /// /// /// /// /// /// ///
  ///    WIDGETS BELOW    ///
  /// /// /// /// /// /// ///

//TODO: Simplify this and standby widget with a single widget that takes a child
  Widget recordingVideo(BuildContext context, VideoRecording state) {
    final inf = BlocProvider.of<InferenceBloc>(context),
        vid = BlocProvider.of<VideoBloc>(context);

    return Center(
      child:
          Stack(alignment: Alignment.center, fit: StackFit.expand, children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: InferencePresenter(videoState: state),
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
                  height: 60,
                  child: BlocBuilder<InferenceBloc, InferenceState>(
                    builder: (context, state) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            "Classification: ${inf.classification ? "Static" : "Sway"}",
                            style: Styles.subactionText),
                        const Spacer(),
                        Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CupertinoSwitch(
                                value: BlocProvider.of<InferenceBloc>(context)
                                    .classification,
                                onChanged: (value) => state is InferenceRunning
                                    ? inf.add(InferenceToggle(value))
                                    : null)),
                      ],
                    ),
                  ),
                ),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () {
                                  BlocProvider.of<VideoBloc>(context)
                                      .add(const VideoRestart());
                                  BlocProvider.of<TimerBloc>(context)
                                      .add(const TimerReset());
                                },
                                child: const Icon(CupertinoIcons.restart,
                                    color: CupertinoColors.black, size: 40)),
                          ),
                          const Spacer(),
                          SafeArea(
                            child:
                                TimerPresenter(onComplete: (durationSeconds) {
                              vid.add(const VideoStop());
                              onComplete(Segment(
                                  duration_seconds: durationSeconds,
                                  file: "TODO"));
                            }),
                          ),
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
                  inf.add(const InferenceEnd());
                  vid.add(const VideoStop());
                  onComplete(Segment(
                      duration_seconds: BlocProvider.of<TimerBloc>(context)
                          .state
                          .duration
                          .inSeconds,
                      file: "TODO"));
                },
                child: const Icon(CupertinoIcons.stop,
                    color: Styles.backgroundComplementory, size: 80)),
          ),
        )
      ]),
    );
  }

  Widget standbyVideo(BuildContext context, VideoStandby videoState) {
    final vid = BlocProvider.of<VideoBloc>(context),
        timer = BlocProvider.of<TimerBloc>(context),
        inf = BlocProvider.of<InferenceBloc>(context),
        screenWidth = MediaQuery.of(context).size.width;

    //TODO Inference and Video Providers need to be weighed and determine which comes first. Currently video is first.

    return Center(
      child:
          Stack(alignment: Alignment.center, fit: StackFit.expand, children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: CameraPreview(videoState.controller),
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
                  height: 60,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Click the record button to start",
                          style: Styles.subactionText),
                    ],
                  ),
                ),
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
                          const SizedBox(),
                          const Spacer(),
                          SafeArea(
                              child:
                                  Text("00.0", style: Styles.timerTextStyle)),
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
            child: BlocBuilder<InferenceBloc, InferenceState>(
                buildWhen: (previous, current) {
              return previous is InferenceLoading &&
                  current is InferenceStopped;
            }, builder: (context, state) {
              if (state is InferenceLoading) {
                return const AppLoading(message: "Loading Model");
              }
              return GestureDetector(
                onTap: () {
                  vid.add(const VideoPlay());
                  timer.add(const TimerStarted());
                  inf.add(InferenceStart(screenWidth /
                      videoState.controller.value.previewSize!.height));
                },
                child: const Icon(CupertinoIcons.circle_fill,
                    color: Styles.actionPrimary, size: 80),
              );
            }),
          ),
        )
      ]),
    );
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
            onPressed: () => vid.add(VideoRestart()),
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }
}
