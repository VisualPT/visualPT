import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/components/_components.dart';

class VideoRecorder extends StatefulWidget {
  final String title;
  const VideoRecorder({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<VideoRecorder> createState() => _VideoRecorderState();
}

class _VideoRecorderState extends State<VideoRecorder>
    with WidgetsBindingObserver {
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

  // // #docregion AppLifecycle
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   final CameraController? cameraController = widget.controller;

  //   // App state changed before we got the chance to initialize.
  //   if (cameraController == null || !cameraController.value.isInitialized) {
  //     return;
  //   }

  //   if (state == AppLifecycleState.inactive) {
  //     cameraController.dispose();
  //   } else if (state == AppLifecycleState.resumed) {
  //     // onNewCameraSelected(cameraController.description);
  //   }
  // }

  // void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
  //   if (widget.controller == null) {
  //     return;
  //   }

  //   final CameraController cameraController = widget.controller!;

  //   final Offset offset = Offset(
  //     details.localPosition.dx / constraints.maxWidth,
  //     details.localPosition.dy / constraints.maxHeight,
  //   );
  //   cameraController.setExposurePoint(offset);
  //   cameraController.setFocusPoint(offset);
  // }

  // Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
  //   final CameraController? oldController = widget.controller;
  //   if (oldController != null) {
  //     // `controller` needs to be set to null before getting disposed,
  //     // to avoid a race condition when we use the controller that is being
  //     // disposed. This happens when camera permission dialog shows up,
  //     // which triggers `didChangeAppLifecycleState`, which disposes and
  //     // re-creates the controller.
  //     widget.controller = null;
  //     await oldController.dispose();
  //   }

  //   final CameraController cameraController = CameraController(
  //     cameraDescription,
  //     ResolutionPreset.max,
  //   );

  //   widget.controller = cameraController;

  //   // If the controller is updated then update the UI.
  //   cameraController.addListener(() {
  //     if (mounted) {
  //       setState(() {});
  //     }
  //     if (cameraController.value.hasError) {
  //       print(
  //           'Camera error ${cameraController.value.errorDescription}');
  //     }
  //   });

  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //TODO Put all this blocProvider jumble in the bloc folder AND delay load until cameraController is ready
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(border: Border.all()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CameraBloc()..add(CameraInit()),
          ),
          BlocProvider(
            create: (context) => TimerBloc(),
          ),
        ],
        child: BlocBuilder<CameraBloc, CameraState>(
          builder: (context, state) {
            try {
              if (state is CameraStandby || state is CameraRecording) {
                return cameraWidget(context, state);
              } else if (state is CameraLoading) {
                //TODO Loading View or throws error message
                return BaseView(
                  pageTitle: widget.title,
                  child: Center(
                    child: Column(
                      children: const [
                        Text("Loading"),
                        CupertinoActivityIndicator()
                      ],
                    ),
                  ),
                );
              } else {
                throw Exception("Invalid State");
              }
            } on Exception catch (e) {
              return BaseView(
                pageTitle: widget.title,
                child: Center(
                  child: Column(
                    children: [
                      Text(e.toString()),
                      CupertinoButton(
                        onPressed: () {
                          BlocProvider.of<CameraBloc>(context)
                              .add(CameraInit());
                        },
                        child: const Text("Restart"),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget cameraWidget(BuildContext context, CameraState state) {
    assert(state is CameraRecording || state is CameraStandby);

    final assessmentBloc = BlocProvider.of<AssessmentBloc>(context);
    final cameraBloc = BlocProvider.of<CameraBloc>(context);
    final timerBloc = BlocProvider.of<TimerBloc>(context);

    return Stack(alignment: Alignment.center, children: [
      const ViewBackground(),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: CameraPreview(
          state.controller!,
          // child: LayoutBuilder(
          //     builder: (_, constraints) => GestureDetector(
          //           onTapDown: (details) =>
          //               onViewFinderTap(details, constraints),
          //         )),
        ),
      ),
      Positioned(
        bottom: 10,
        child: GestureDetector(
            onTap: () {
              if (state is CameraRecording) {
                timerBloc.add(const TimerReset());
                saveCameraDataToAssessment(assessmentBloc, cameraBloc);
              } else {
                cameraBloc.add(CameraPlay());
                timerBloc.add(const TimerStarted());
              }
            },
            child: state is CameraRecording
                ? const Icon(CupertinoIcons.stop,
                    color: Styles.backgroundComplementory, size: 80)
                : const Icon(CupertinoIcons.circle,
                    color: Styles.actionPrimary, size: 80)),
      ),
      const Positioned(top: 10, child: VideoTimer())
    ]);
  }
}
