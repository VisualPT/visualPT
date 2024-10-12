import 'dart:async';
import 'dart:developer';
import 'package:amplify_flutter/amplify_flutter.dart' as amplify;
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/inference/view/pose_detection_indicator.dart';
import 'package:visualpt/features/video/service/video_detection_repository.dart';
import 'package:visualpt/models/ModelProvider.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc(this.videoDetectionRepo, this.totalDuration, this.storeData)
      : _ticker = Ticker(duration: totalDuration),
        super(const VideoLoading()) {
    on<VideoInit>(onInit);
    on<VideoPlay>(onPlay);
    on<VideoPause>(onPause);
    on<VideoTick>(onTick);
    on<VideoStop>(onStop);
  }
  final VideoDetectionRepository videoDetectionRepo;
  late CameraController? controller;
  final bool storeData;
  late Duration videoDuration = const Duration(seconds: 0);
  final Duration totalDuration;
  final Ticker _ticker;
  StreamSubscription<Duration>? _tickerSubscription;
  amplify.TemporalDateTime? _start;

  FutureOr<void> onInit(VideoInit event, Emitter<VideoState> emit) async {
    try {
      final cameras = await availableCameras();
      //TODO: Add a check for the camera capabilities (are we on simulator?)
      controller = CameraController(
        cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back),
        ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.bgra8888,
      );
      await controller!.initialize();
      await controller?.lockCaptureOrientation();
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
    _start = amplify.TemporalDateTime(DateTime.now());
    if (controller == null) {
      emit(VideoError(
          exception: Exception("Camera controller was not initialized")));
    }
    controller!.startVideoRecording(onAvailable: (image) {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final measurements = DetectionEnv(
          imageHeight: image.height,
          imageWidth: image.width,
          accX: videoDetectionRepo.currentAccel.x,
          accY: videoDetectionRepo.currentAccel.y,
          accZ: videoDetectionRepo.currentAccel.z,
          gyroX: videoDetectionRepo.currentGyro.x,
          gyroY: videoDetectionRepo.currentGyro.y,
          gyroZ: videoDetectionRepo.currentGyro.z);
      videoDetectionRepo.add(DeviceCapture(id, image, measurements));
    });
    _tickerSubscription?.cancel();
    _tickerSubscription =
        _ticker.tick().listen((duration) => add(VideoTick(duration: duration)));
  }

  FutureOr<void> onPause(VideoPause event, Emitter<VideoState> emit) async {
    //Prevent the video from adding any more resources into the repo
    //Pause the timer
    _tickerSubscription?.pause();
    emit(VideoPaused(controller!, videoDuration));
  }

  FutureOr<void> onTick(VideoTick event, Emitter<VideoState> emit) async {
    emit(
      event.duration < totalDuration
          ? VideoRecording(controller!, _start!, event.duration, false)
          : VideoRecording(controller!, _start!, totalDuration, true),
    );
  }

  FutureOr<void> onStop(VideoStop event, Emitter<VideoState> emit) async {
    _tickerSubscription?.cancel();
    if (_start == null) {
      print("There is no start time to label the video.");
    } else {
      videoDuration = DateTime.now().difference(_start!.getDateTimeInUtc());
      if (controller != null &&
          (controller!.value.isStreamingImages ||
              controller!.value.isRecordingVideo)) {
        final file = await controller!.stopVideoRecording();
        if (event.reset) {
          emit(VideoStandby(controller!));
          return;
        }
        if (storeData) {
          videoDetectionRepo.saveVideo(
              _start!.getDateTimeInUtc().millisecondsSinceEpoch.toString(),
              file);
        }
        emit(VideoEnded(file, videoDuration));
      } else {
        log("Video was already stopped $controller ${controller!.value.isRecordingVideo}");
        emit(VideoEnded(null, videoDuration));
      }
      emit(const VideoLoading());
      controller!.dispose();
    }
  }

  // @override
  // void onTransition(Transition<VideoEvent, VideoState> transition) {
  //   // Always call super.onTransition with the current transition
  //   super.onTransition(transition);
  //   log('VideoBloc: $transition');
  // }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // Always call super.onError with the current error
    super.onError(error, stackTrace);
    debugPrint('VideoBloc Error: $error, $stackTrace');
  }
  // Future<File> getData() async {
  // }
}

class Ticker {
  static const increment = 10;
  final Duration duration;
  const Ticker({required this.duration});
  Stream<Duration> tick() {
    return Stream.periodic(
      const Duration(milliseconds: increment),
      (x) => Duration(milliseconds: increment * x),
    ).takeWhile(
      (d) => d <= duration,
    );
  }
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
