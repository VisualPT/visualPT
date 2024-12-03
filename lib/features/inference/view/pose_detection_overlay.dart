import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/inference/view/camera_painters/ctsib_overlays.dart';
import 'package:visualpt/features/inference/view/camera_painters/pose_overlay.dart';
import 'package:visualpt/features/inference/view/inference_presenter.dart';
import 'package:visualpt/features/inference/view/pose_detection_indicator.dart';

class PoseDetectionOverlay extends StatelessWidget {
  const PoseDetectionOverlay({super.key, required this.controller});
  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return InferencePresenter<DeviceCapture, PoseDetectionOutput>(
      onRunning: onRunning,
      onStandby: onStandby,
      onLoad: onLoad,
      onError: onError,
    );
  }

  Widget onRunning(BuildContext context,
      InferenceRunning<DeviceCapture, PoseDetectionOutput> state) {
    final response = state.response;
    return Stack(
      alignment: Alignment.topLeft,
      fit: StackFit.expand,
      children: [
        PoseBbox(response?.landmarks),
        PoseSway(points: response?.landmarks, accelData: response?.accelData),
        response != null
            ? response
                    .exceedsHeightThreshold(controller.value.previewSize!.width)
                ? PoseOverlay(points: response.landmarks)
                : const Center(child: Text("Get closer!"))
            : const Center(child: Text("Keep subject in frame!"))
      ],
    );
  }

  Widget onStandby(BuildContext context,
      InferenceStandby<DeviceCapture, PoseDetectionOutput> state) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        PoseBbox(null),
      ],
    );
  }

  Widget onLoad(BuildContext context,
      InferenceLoading<DeviceCapture, PoseDetectionOutput> state) {
    return Container();
  }

  Widget onError(BuildContext context,
      InferenceError<DeviceCapture, PoseDetectionOutput> state) {
    return Container();
  }
}
