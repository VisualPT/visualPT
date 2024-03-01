import 'dart:async';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/video/service/video_repository.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc(this.videoRepository) : super(const VideoLoading()) {
    on<VideoInit>(onInit);
    on<VideoPlay>(onPlay);
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
      emit(VideoError(
          exception: Exception("Camera controller was not initialized")));
    }
    controller!.startImageStream((image) {
      videoRepository.add(image);
    });
    emit(VideoRecording(controller!));
  }

  FutureOr<void> onStop(VideoStop event, Emitter<VideoState> emit) async {
    duration = DateTime.now().difference(start);
    if (controller != null && controller!.value.isStreamingImages) {
      if (event.reset) {
        emit(VideoStandby(controller!));
      }
      await controller!.stopImageStream();
    } else {
      log("Video was already stopped $controller ${controller!.value.isRecordingVideo}");
    }
    controller!.dispose();
    emit(const VideoLoading());
  }

  @override
  void onTransition(Transition<VideoEvent, VideoState> transition) {
    // Always call super.onTransition with the current transition
    super.onTransition(transition);
    log('VideoBloc: $transition');
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // Always call super.onError with the current error
    super.onError(error, stackTrace);
    debugPrint('VideoBlock Error: $error, $stackTrace');
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
