import 'dart:async';
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
  CameraBloc() : super(CameraLoading()) {
    on<CameraInit>(_cameraInit);
    on<CameraPlay>(_cameraPlay);
    on<CameraPause>(_cameraPause);
    on<CameraSave>(_cameraSave);
  }

  void resetTimer() {
    timer?.cancel();
    duration = const Duration(seconds: 0);
  }

  // void triggerState(BuildContext context, CameraState state) async {
  //   try {
  //     if (state is CameraRecording) {
  //       resetTimer();
  //       XFile file = await state.controller.stopVideoRecording();
  //       CupertinoPageRoute route = CupertinoPageRoute(
  //           fullscreenDialog: true,
  //           builder: (_) => EditorPage(file: File(file.path)));
  //       Navigator.push(context, route);
  //       initCamera();
  //     } else if (state is CameraStandby) {
  //       startTimer(state.controller);
  //       state.controller.startVideoRecording();
  //     }
  //   } on Exception catch (e) {
  //     resetTimer();
  //     emit(CameraError(exception: e));
  //   }
  // }

  // void resetCamera() async {
  //   emit(CameraLoading());
  //   initCamera();
  // }

  FutureOr<void> _cameraInit(
      CameraInit event, Emitter<CameraState> emit) async {
    try {
      await getCamera()
          .then((_) => emit(CameraStandby(controller: cameraController!)))
          .onError((error, stackTrace) =>
              emit(CameraError(exception: Exception(error))));
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

  FutureOr<void> _cameraPlay(CameraPlay event, Emitter<CameraState> emit) {
    timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      duration = Duration(milliseconds: duration.inMilliseconds + 10);

      emit(CameraRecording(controller: cameraController!, duration: duration));
    });
  }

  FutureOr<void> _cameraPause(CameraPause event, Emitter<CameraState> emit) {}

  FutureOr<void> _cameraSave(
      CameraSave event, Emitter<CameraState> emit) async {
    final XFile data = await cameraController!.stopVideoRecording();
    cameraController!.dispose();
    getCamera();
  }

  Future<void> getCamera() async {
    try {
      await availableCameras()
          .then((cameras) => cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back))
          .then((camera) => CameraController(
                camera,
                ResolutionPreset.max,
                enableAudio: false,
                imageFormatGroup: ImageFormatGroup.bgra8888,
              ))
          .then((controller) {
            controller.initialize();
            return controller;
          })
          .then((controller) => cameraController = controller)
          .onError((error, stackTrace) => throw Exception(error));
    } on Exception catch (e) {
      emit(CameraError(exception: e));
    }
  }
}
