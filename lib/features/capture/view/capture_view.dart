import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/features/capture/service/capture_repository.dart';
import 'package:visualpt/features/capture/bloc/capture_bloc.dart';
import 'package:visualpt/features/capture/view/capture_indicator.dart';
import 'package:visualpt/features/capture/view/pose_detection_indicator.dart';
import 'package:visualpt/features/capture/view/capture_presenter.dart';

class CaptureView<T extends BaseAssessment> extends StatelessWidget {
  final AssessmentActive<T> state;
  const CaptureView(this.state, {super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CapturePresenter(
          key: UniqueKey(),
          state.storeData,
          state.trialMeta,
          state.meta.trialDuration,
          onDelegated: delegatedCapture,
          onEnded: endedCapture,
          onError: errorCapture,
        ),
      ],
    );
  }

  /// /// /// /// /// /// ///
  ///    WIDGETS BELOW    ///
  /// /// /// /// /// /// ///

  Widget delegatedCapture(BuildContext context, CaptureDelegated state) {
    final capture = BlocProvider.of<CaptureBloc>(context);
    final asmt = BlocProvider.of<AssessmentBloc<T>>(context);
    final capRep = RepositoryProvider.of<CaptureRepository>(context);

    void onPlay() {
      capture.add(const CapturePlay());
    }

    void onReset() {
      // End Capture
      capture.add(const CaptureStop(reset: true));
    }

    void onComplete() {
      capture.add(const CaptureStop(reset: false));

      asmt.add(
        AssessmentTrial(
          capRep.localStorage.values.toList(),
          capture.start,
          state.duration,
        ),
      );
    }

    void onPause() {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoPopupSurface(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Capture Paused",
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
                        onPressed: () {
                          Navigator.of(context).pop();
                          onReset();
                        },
                        child: const Text("Reset"),
                      ),
                      // Next
                      CupertinoButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onComplete();
                        },
                        child: const Text("Next"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    if (state.shouldEnd ||
        (state.duration >= Duration(seconds: asmt.meta.trialDuration) ||
            asmt.meta.isComplete(state.detection))) {
      onPause();
    }

    void handleWebViewMessage(WebViewMessage message) {
      //TODO: Handle Kinestex messages
      //if (message is KinestexLaunched) {
      // capture.add(CaptureLaunched(message.data));
      // } else if (message is ExitKinestex || message is ExerciseCompleted) {
      //   capture.add(CaptureComplete(message.data));
      // } else if (message is Mistake || message is LeftCameraFrame) {
      //   capture.add(CaptureWarn(message.data));
      // } else if (message is ReturnedCameraFrame) {
      //   capture.add(CaptureClearWarn(message.data));
      // } else
      if (message.data['type'] == 'raw_landmarks') {
        capture.add(CaptureLandmark(message.data));
      }
    }

    return SafeArea(
        child: Stack(
      alignment: Alignment.topCenter,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
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
                          PoseDetectionIndicator(state.detection),
                        ],
                      ),
                    ),
                  ),
                ),
                dotenv.env["KINESTEX_KEY"] != null
                    ? KinesteXAIFramework.createCameraComponent(
                        apiKey: dotenv.env["KINESTEX_KEY"]!,
                        companyName: "VisualPT",
                        userId:
                            'b8f8e10a-4677-4c6c-aa80-0c328a8fd9aa', //TODO: Replace with user ID
                        isShowKinestex: ValueNotifier<bool>(false),
                        exercises: ['Balance'],
                        currentExercise: 'Balance',
                        isLoading: ValueNotifier<bool>(false), // Loading state
                        customParams: {"includeRawData": true},
                        onMessageReceived: handleWebViewMessage,
                      )
                    : const Center(
                        child: Text(
                            "Key not found, please report this issue to us"),
                      ),
                Positioned(
                  bottom: 10,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Spacer(),
                      if (!state.playing) ...[
                        //Space filling icon to align the others in the row
                        const Spacer(),
                        GestureDetector(
                          onTap: onPlay,
                          child: const Icon(
                            CupertinoIcons.circle,
                            color: Styles.actionPrimary,
                            size: 80,
                          ),
                        ),
                        const Spacer(),
                      ] else ...[
                        const Spacer(),
                        GestureDetector(
                          onTap: onPause,
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
        )
      ],
    ));
  }

  Widget endedCapture(BuildContext context, CaptureEnded state) {
    final vid = BlocProvider.of<CaptureBloc>(context);
    return Center(
      child: Column(
        children: [
          const Text("Capture Stopped"),
          CupertinoButton(
            onPressed: () => vid.add(const CaptureStop(reset: true)),
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }

  Widget errorCapture(BuildContext context, CaptureState state, Exception e) {
    final vid = BlocProvider.of<CaptureBloc>(context);
    return Center(
      child: Column(
        children: [
          Text(e.toString()),
          CupertinoButton(
            onPressed: () => vid.add(const CaptureStop(reset: true)),
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }
}

String formatter(Duration duration) => [
      duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
      duration.inMilliseconds.remainder(1000).toString().padLeft(3, '0')[0]
    ].join(".");
