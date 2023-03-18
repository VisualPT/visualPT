import 'dart:async';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class VideoOutput {
  final XFile? file;
  final Duration? duration;
  const VideoOutput({this.file, this.duration});

  @override
  toString() => "VideoOutput(file: $file, duration: $duration)";
}

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraController? cameraController;
  Timer? timer;
  late Duration duration = const Duration(seconds: 0);
  late DateTime start;
  late void Function(VideoOutput) onComplete;

  CameraBloc() : super(const CameraLoading()) {
    on<CameraInit>(onInit);
    on<CameraPlay>(onPlay);
    on<CameraStop>(onStop);
  }

  void resetTimer() {
    timer?.cancel();
    duration = const Duration(seconds: 0);
  }

  FutureOr<void> onInit(CameraInit event, Emitter<CameraState> emit) async {
    log("camera init");
    onComplete = event.onComplete;
    try {
      await availableCameras()
          .then(
        (cameras) => CameraController(
          cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back),
          ResolutionPreset.max,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.bgra8888,
        ),
      )
          .then((controller) async {
        await controller.initialize();
        cameraController = controller;
        emit(CameraStandby(cameraController!));
      });

      log("Camera initialized, lauming frame reader");
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
          emit(CameraError(exception: e));
          break;
      }
    } on Exception catch (e) {
      emit(CameraError(exception: e));
    }
  }

  FutureOr<void> onPlay(CameraPlay event, Emitter<CameraState> emit) async {
    log("camera play");
    start = DateTime.now();
    emit(CameraRecording(cameraController!));
  }

  FutureOr<void> onStop(CameraStop event, Emitter<CameraState> emit) async {
    log("camera stop");
    await cameraController!.stopVideoRecording().then((file) {
      duration = DateTime.now().difference(start);
      onComplete(VideoOutput(file: file, duration: duration));
    });
    //TODO Pass data up!
    cameraController!.dispose();
    cameraController = null;
    emit(const CameraLoading());
  }

  //TODO update this to output a Map<String, dynamic> instead of a file
  // Future<File> getData() async {
  // }
}

//TODO create an onFocus state for this
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
