import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/views/_views.dart';

class VideoRecorder extends StatefulWidget {
  final String title;
  final CameraController? controller;
  final void Function(File f) onCaptureSaved;
  const VideoRecorder(
      {Key? key,
      required this.title,
      this.controller,
      required this.onCaptureSaved})
      : super(key: key);

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

  // #docregion AppLifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = widget.controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // onNewCameraSelected(cameraController.description);
    }
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (widget.controller == null) {
      return;
    }

    final CameraController cameraController = widget.controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

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
    //TODO Put all this blocProvider jumble in the bloc folder
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(border: Border.all()),
      child: BlocProvider(
        create: (context) => CameraBloc()..add(CameraInit()),
        child: BlocBuilder<CameraBloc, CameraState>(
          builder: (context, state) {
            return state is CameraError
                ? BaseView(
                    pageTitle: widget.title,
                    child: Center(
                      child: Column(
                        children: [
                          Text(state.exception.toString()),
                          CupertinoButton(
                              onPressed: () {
                                // BlocProvider.of<CameraBloc>(context)
                                //     .resetCamera();
                              },
                              child: const Text("Restart Camera"))
                        ],
                      ),
                    ),
                  )
                : cameraWidget(context, state);
          },
        ),
      ),
    );
  }

  Widget stopwatchWidget(BuildContext context, CameraState state) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 8,
      width: MediaQuery.of(context).size.width / 2,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: CupertinoColors.systemRed,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
              (() {
                if (state is CameraRecording) {
                  return formatter(state.duration);
                } else {
                  return formatter(const Duration(seconds: 0));
                }
              }()),
              style: const TextStyle(color: Color(0xFF000000))),
        ),
      ),
    );
  }

  Widget cameraWidget(BuildContext context, CameraState state) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Stack(
        alignment: Alignment.center,
        children: (() {
          if (state is CameraRecording) {
            return [
              CameraPreview(state.controller),
              Positioned(
                bottom: 10,
                child: GestureDetector(
                  onTap: () =>
                      BlocProvider.of<CameraBloc>(context).add(CameraSave()),
                  child: const Icon(
                    CupertinoIcons.stop,
                    color: CupertinoColors.systemRed,
                    size: 80,
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Row(
                  children: [
                    stopwatchWidget(context, state),
                  ],
                ),
              ),
            ];
          } else if (state is CameraStandby) {
            return [
              CameraPreview(state.controller),
              Positioned(
                bottom: 10,
                child: GestureDetector(
                  // onTap: () => BlocProvider.of<CameraBloc>(context)
                  //     .triggerState(context, state),
                  child: const Icon(
                    CupertinoIcons.circle,
                    color: CupertinoColors.black,
                    size: 80,
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Row(
                  children: [
                    stopwatchWidget(context, state),
                  ],
                ),
              ),
            ];
          } else {
            return [const Center(child: CupertinoActivityIndicator())];
          }
        }()),
      ),
    );
  }

  String formatter(Duration duration) => [
        duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
        duration.inMilliseconds.remainder(1000).toString().padLeft(3, '0')[0]
      ].join(".");
}
