import 'dart:async';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/repository/video_repository.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc(this.videoRepository) : super(const VideoLoading()) {
    on<VideoInit>(onInit);
    on<VideoPlay>(onPlay);
    on<VideoRestart>(onRestart);
    on<VideoStop>(onStop);
  }
  final VideoRepository videoRepository;
  late CameraController? controller;
  late Duration duration = const Duration(seconds: 0);
  late DateTime start;

  FutureOr<void> onInit(VideoInit event, Emitter<VideoState> emit) async {
    try {
      final cameras = await availableCameras();
      controller = CameraController(
        cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back),
        ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.bgra8888,
      );
      await controller!.initialize();
      emit(VideoStandby(controller!));
    } on CameraException catch (e) {
      //TODO create a popup for these error codes
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
    if (controller == null) {
      //TODO:Error handle instead
      if (!isClosed) add(const VideoInit());
    }
    videoRepository.startRecording(controller!);
    emit(VideoRecording(controller!));
  }

  FutureOr<void> onRestart(VideoRestart event, Emitter<VideoState> emit) {
    log("Restarting video");
    if (controller == null) {
      if (!isClosed) add(const VideoInit());
    } else {
      controller!.stopImageStream();
      emit(VideoStandby(controller!));
    }
  }

  FutureOr<void> onStop(VideoStop event, Emitter<VideoState> emit) async {
    if (controller!.value.isRecordingVideo) {
      await controller!.stopImageStream();
    } else {
      log("Video was already stopped");
    }
    duration = DateTime.now().difference(start);
    controller!.dispose();
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
