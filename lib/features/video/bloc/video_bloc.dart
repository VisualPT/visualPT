import 'dart:async';
import 'dart:developer';
import 'package:amplify_flutter/amplify_flutter.dart' as amplify;
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/inference/view/pose_detection_indicator.dart';
import 'package:visualpt/features/video/service/capture_repository.dart';
import 'package:visualpt/models/ModelProvider.dart';

part 'video_event.dart';
part 'video_state.dart';

//TODO: Prevent the user from stopping the camera too soon, add a delay
// Ref: https://github.com/flutter/flutter/issues/121659
class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc(this.repo, this.totalDuration, this.storeData)
      : _ticker = Ticker(duration: totalDuration),
        super(const VideoLoading()) {
    on<VideoInit>(onInit);
    on<VideoPlay>(onPlay);
    on<VideoFocus>(onFocus);
    on<VideoSwitch>(onSwitch);
    on<VideoPause>(onPause);
    on<VideoTick>(onTick);
    on<VideoStop>(onStop);
  }

  final CaptureRepository repo;
  late List<CameraDescription>? cameras;
  late CameraController? controller;
  final bool storeData;
  late Duration videoDuration = const Duration(seconds: 0);
  final Duration totalDuration;
  final Ticker _ticker;
  StreamSubscription<Duration>? _tickerSubscription;
  amplify.TemporalDateTime? _start;

  FutureOr<void> onInit(VideoInit event, Emitter<VideoState> emit) async {
    try {
      //TODO: Add a check for the camera capabilities (are we on simulator?)
      cameras = await availableCameras();
      final description = cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back);
      controller = await _initializeCameraController(description);
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
          accX: repo.currentAccel.x,
          accY: repo.currentAccel.y,
          accZ: repo.currentAccel.z,
          timestamp: amplify.TemporalDateTime(repo.currentAccel.timestamp));
      !isClosed ? repo.add(DeviceCapture(id, image, measurements)) : null;
    });
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick().listen((duration) =>
        //if the bloc is closed, cancel the subscription
        !isClosed
            ? add(VideoTick(duration: duration))
            : _tickerSubscription?.cancel());
  }

  FutureOr<void> onFocus(VideoFocus event, Emitter<VideoState> emit) async {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      event.localPosition.dx / event.constraints.maxWidth,
      event.localPosition.dy / event.constraints.maxHeight,
    );

    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  FutureOr<void> onSwitch(VideoSwitch event, Emitter<VideoState> emit) async {
    if (controller == null) {
      return;
    }

    cameras = cameras ??= await availableCameras();
    final description = cameras!.firstWhere((camera) =>
        camera.lensDirection != controller!.description.lensDirection);
    controller = await _initializeCameraController(description);

    emit(VideoStandby(controller!));
  }

  FutureOr<void> onTick(VideoTick event, Emitter<VideoState> emit) async {
    emit(
      event.duration < totalDuration
          ? VideoRecording(controller!, _start!, event.duration, false)
          : VideoRecording(controller!, _start!, totalDuration, true),
    );
  }

  FutureOr<void> onPause(VideoPause event, Emitter<VideoState> emit) async {
    try {
      _tickerSubscription?.cancel();
      videoDuration = DateTime.now().difference(_start!.getDateTimeInUtc());
      if (controller != null &&
          (controller!.value.isStreamingImages ||
              controller!.value.isRecordingVideo)) {
        final file = await controller!.stopVideoRecording();
        emit(VideoPaused(controller!, file, _start!, videoDuration));
        return;
      }
      throw Exception(
          "Video was already stopped $controller ${controller!.value.isRecordingVideo}");
    } on Exception catch (e) {
      emit(VideoError(exception: e));
    }
  }

  FutureOr<void> onStop(VideoStop event, Emitter<VideoState> emit) async {
    try {
      _tickerSubscription?.cancel();
      if (_start == null) {
        print("There is no start time to label the video.");
      } else {
        if (event.reset) {
          return emit(VideoStandby(controller!));
        }
        if (storeData && event.file != null) {
          repo.saveVideo(
              _start!.getDateTimeInUtc().millisecondsSinceEpoch.toString(),
              event.file!);
        }
        emit(const VideoEnded(Duration.zero));
        controller!.dispose();
        repo.dispose();
      }
    } catch (e) {
      emit(VideoError(exception: Exception(e)));
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // Always call super.onError with the current error
    super.onError(error, stackTrace);
    debugPrint('VideoBloc Error: $error, $stackTrace');
  }

  Future<CameraController> _initializeCameraController(
      CameraDescription description) async {
    final controller = CameraController(description, ResolutionPreset.low,
        enableAudio: false, imageFormatGroup: ImageFormatGroup.bgra8888);
    await controller.initialize();
    await controller.lockCaptureOrientation();
    return controller;
  }
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
