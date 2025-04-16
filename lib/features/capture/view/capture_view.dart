import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
    return CapturePresenter(
      state.meta,
      onDelegated: delegatedCapture,
      onEnded: endedCapture,
      onError: errorCapture,
    );
  }

  /// /// /// /// /// /// ///
  ///    WIDGETS BELOW    ///
  /// /// /// /// /// /// ///

  Widget delegatedCapture(BuildContext context, CaptureDelegated state) {
    final capture = BlocProvider.of<CaptureBloc>(context);
    final asmt = BlocProvider.of<AssessmentBloc<T>>(context);

    void onPlay() => capture.add(CapturePlay());
    void onPause() => capture.add(CapturePause());
    void onMessageReceived(WebViewMessage message) =>
        capture.add(CaptureMessage(message, state.playing));

    if (state.playing &&
        state.countdown == 0 &&
        asmt.config.isComplete(state.detection)) {
      //Think about this a little more. What do we want this language to be? How do we design this to work with the Kinestex SDK and the BaseAssessment class
      //TODO: Can use the pose classification model within the isComplete function to check WHICH pose was detected and then return a different warning message for each pose
      capture.add(CaptureWarn("Fall Detected", decay: 5));
    }

    return Column(
      children: [
        Container(
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
                  color: state.countdown > 0 ? Styles.yellow : Styles.green,
                  type: state.playing && state.countdown > 0
                      ? "Countdown"
                      : "Duration",
                  child: Text(
                      state.playing && state.countdown > 0
                          ? state.countdown.toString()
                          : formatter(state.playing
                              ? capture.duration
                              : capture.totalDuration),
                      style: Styles.timerTextStyle),
                ),
                PoseLandmarksIndicator(state.detection,
                    message: !state.playing ? "Start the trial" : null),
                kDebugMode
                    ? CaptureIndicator(
                        icon: CupertinoIcons.device_phone_portrait,
                        type: "Device",
                        child: Text(
                            //display the pitch and yaw angles using capture.repo.currentAccel
                            '${(atan2(-capture.repo.currentAccel.x, sqrt(capture.repo.currentAccel.y * capture.repo.currentAccel.y + capture.repo.currentAccel.z * capture.repo.currentAccel.z)) * (180 / pi)).toInt()}° / ${(capture.repo.currentAccel.y != 0) ? (atan(capture.repo.currentAccel.z / capture.repo.currentAccel.y) * (180 / pi)).toInt() : 0}°',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              fontFamily: 'monospace',
                            )))
                    : Container(),
              ],
            ),
          ),
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              dotenv.env["KINESTEX_KEY"] != null
                  ? KinesteXAIFramework.createCameraComponent(
                      apiKey: dotenv.env["KINESTEX_KEY"]!,
                      companyName: "VisualPT",
                      userId:
                          'b8f8e10a-4677-4c6c-aa80-0c328a8fd9aa', //TODO: Replace with user ID
                      isShowKinestex: ValueNotifier<bool>(false),
                      exercises: [],
                      currentExercise: '',
                      isLoading: ValueNotifier<bool>(false), // Loading state
                      customParams: {
                        "includePoseData": ['worldLandmarks'],
                        "landmarkColor": Styles.skyBlueString,
                        "shouldShowCameraSelector": true,
                      },
                      onMessageReceived: onMessageReceived,
                    )
                  : const Center(
                      child:
                          Text("Key not found, please report this issue to us"),
                    ),
              // Positioned in the center a piece of text that has the state.message in it when it is defined.
              if (state.message.isNotEmpty)
                Positioned(
                  width: MediaQuery.of(context).size.width,
                  top: MediaQuery.of(context).size.height / 2,
                  child: Center(
                    child: Container(
                      color: Styles.white,
                      child: Text(state.message,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
              if (!state.selector) ...[
                Positioned(
                  bottom: 0,
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
                      ] else if (state.countdown == 0) ...[
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
              ]
            ],
          ),
        ),
      ],
    );
  }

  Widget endedCapture(BuildContext context, CaptureEnded state) {
    final asmt = BlocProvider.of<AssessmentBloc<T>>(context);
    final capture = BlocProvider.of<CaptureBloc>(context);
    final capRep = RepositoryProvider.of<CaptureRepository>(context);

    void onComplete() {
      asmt.add(
        AssessmentTrial(capRep.localStorage.values.toList(), capture.start,
            capture.duration, asmt.state.formFields),
      );
      capture.add(CaptureStop(reset: false));
    }

    return BaseView(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Capture Ended",
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
              style: Styles.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Reset
                Button(
                  onPressed: () => capture.add(CaptureStop(reset: true)),
                  text: "Reset",
                ),
                // Next
                Button(
                  onPressed: onComplete,
                  text: "Next",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget errorCapture(BuildContext context, CaptureState state, Exception e) {
    final vid = BlocProvider.of<CaptureBloc>(context);
    return BaseView(
      child: Center(
        child: Column(
          children: [
            Text(e.toString()),
            Button(
              onPressed: () => vid.add(CaptureStop(reset: true)),
              text: "Restart",
            ),
          ],
        ),
      ),
    );
  }
}

String formatter(Duration duration) => [
      duration.inMinutes.toString().padLeft(2, '0'),
      duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
      duration.inMilliseconds.remainder(1000).toString().padLeft(3, '0')[0]
    ].join(":");
