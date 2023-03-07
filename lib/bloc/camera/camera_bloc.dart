import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraController? cameraController;
  Timer? timer;
  Duration duration = const Duration(seconds: 0);
  late File output;
  CameraBloc() : super(CameraLoading()) {
    on<CameraInit>(_onInit);
    on<CameraPlay>(_onPlay);
    on<CameraPause>(_onPause);
    on<CameraStop>(_onStop);
  }

  void resetTimer() {
    timer?.cancel();
    duration = const Duration(seconds: 0);
  }

  FutureOr<void> _onInit(CameraInit event, Emitter<CameraState> emit) async {
    log("camera init");
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

      log("In standby");
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          print('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          print('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
          print('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          print('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          print('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
          print('Audio access is restricted.');
          break;
        default:
          emit(CameraError(exception: e));
          break;
      }
    } on Exception catch (e) {
      emit(CameraError(exception: e));
    }
  }

  FutureOr<void> _onPlay(CameraPlay event, Emitter<CameraState> emit) async {
    log("camera play");
    await cameraController!.startVideoRecording();

    emit(CameraRecording(cameraController!));
  }

  FutureOr<void> _onPause(CameraPause event, Emitter<CameraState> emit) {
    log("camera pause");
  }

  FutureOr<void> _onStop(CameraStop event, Emitter<CameraState> emit) async {
    output = await cameraController!
        .stopVideoRecording()
        .then((file) => File(file.path));
    log(output.toString());
    //TODO Pass data up!
    cameraController!.dispose();
    emit(const CameraLoading());
  }

  Future<File> getData() async {
    //TODO Make more reliable!
    return await Future.delayed(const Duration(seconds: 1), () => output);
  }
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
