import 'dart:async';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoOutput {
  final XFile? file;
  final Duration? duration;
  const VideoOutput({this.file, this.duration});

  @override
  toString() => "VideoOutput(file: $file, duration: $duration)";
}

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  Timer? timer;
  late Duration duration = const Duration(seconds: 0);
  late DateTime start;
  late void Function(Segment) onComplete;

  VideoBloc() : super(const VideoLoading()) {
    on<VideoInit>(onInit);
    on<VideoPlay>(onPlay);
    on<VideoRestart>(onRestart);
    on<VideoStop>(onStop);
  }

  void resetTimer() {
    timer?.cancel();
    duration = const Duration(seconds: 0);
  }

  FutureOr<void> onInit(VideoInit event, Emitter<VideoState> emit) async {
    onComplete = event.onComplete;
    try {
      await availableCameras()
          .then(
        (cameras) => CameraController(
          cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back),
          ResolutionPreset.high,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.bgra8888,
        ),
      )
          .then((controller) async {
        await controller.initialize();
        emit(VideoStandby(controller));
      });

      //TODO create a popup for these error codes
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          log('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          log('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
          log('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          log('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          log('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
          log('Audio access is restricted.');
          break;
        default:
          emit(VideoError(exception: e));
          break;
      }
    } on Exception catch (e) {
      emit(VideoError(exception: e));
    }
  }

  FutureOr<void> onPlay(VideoPlay event, Emitter<VideoState> emit) async {
    start = DateTime.now();
    emit(VideoRecording(event.controller));
  }

  FutureOr<void> onRestart(VideoRestart event, Emitter<VideoState> emit) {
    print("Restarting video");
    event.controller.stopVideoRecording();
    resetTimer();
    emit(VideoStandby(event.controller));
  }

  FutureOr<void> onStop(VideoStop event, Emitter<VideoState> emit) async {
    if (event.controller.value.isRecordingVideo) {
      await event.controller.stopVideoRecording();
    } else {
      print("Video was already stopped");
    }
    duration = DateTime.now().difference(start);
    //TODO store file to S3 bucket
    onComplete(Segment(
        file: "TODO store file to S3", duration_seconds: duration.inSeconds));

    event.controller.dispose();
    emit(const VideoLoading());
  }

  // Future<File> getData() async {
  // }
}

//TODO create an onFocus state for this in the view file
// void onFocus(TapDownDetails details, BoxConstraints constraints) {
//   if (cameraController == null) {
//     return;
//   }

//   final Offset offset = Offset(
//     details.localPosition.dx / constraints.maxWidth,
//     details.localPosition.dy / constraints.maxHeight,
//   );
//   cameraController.setExposurePoint(offset);
//   cameraController.setFocusPoint(offset);
// }


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
//       log('Camera error ${cameraController.value.errorDescription}');
//     }
//   });

//   if (mounted) {
//     setState(() {});
//   }
// }
