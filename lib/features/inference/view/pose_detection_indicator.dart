import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/inference/view/camera_painters/ctsib_overlays.dart';
import 'package:visualpt/features/inference/view/inference_indicator.dart';
import 'package:visualpt/features/inference/view/inference_presenter.dart';

class CameraCapture extends Identifiable {
  final CameraImage input;
  const CameraCapture(super.id, this.input);
}

class PoseDetectionIndicator extends StatelessWidget {
  const PoseDetectionIndicator({super.key});
  static const icon = CupertinoIcons.person;
  static const type = "Pose Detection";

  @override
  Widget build(BuildContext context) {
    return InferencePresenter<CameraCapture, PoseDetectionOutput>(
      onRunning: onRunning,
      onStandby: onStandby,
      onLoad: onLoad,
      onError: onError,
    );
  }

  Widget onRunning(BuildContext context,
      InferenceRunning<CameraCapture, PoseDetectionOutput> state) {
    final offsets = state.response != null
        ? computeLineOfBestFit(
            state.response!.landmarks.sublist(0, 34), const Size(256, 256))
        : null;
    final color = offsets != null
        ? offsets.degrees.abs() < MAX_SWAY_ANGLE
            ? CupertinoColors.systemGreen
            : CupertinoColors.systemYellow
        : CupertinoColors.systemRed;
    return InferenceIndicator(
      icon: icon,
      color: CupertinoColors.activeGreen,
      type: type,
      message: "Running",
      formattedTextWidget: Text(
          "${offsets?.degrees.toStringAsFixed(1) ?? "0.0"}°",
          style: TextStyle(fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget onStandby(BuildContext context,
      InferenceStandby<CameraCapture, PoseDetectionOutput> state) {
    return const InferenceIndicator(
        icon: icon,
        color: CupertinoColors.systemYellow,
        type: type,
        message: "Standby");
  }

  Widget onLoad(BuildContext context,
      InferenceLoading<CameraCapture, PoseDetectionOutput> state) {
    return const InferenceIndicator(
        icon: icon,
        color: CupertinoColors.systemGrey,
        type: type,
        message: "Loading");
  }

  Widget onError(BuildContext context,
      InferenceError<CameraCapture, PoseDetectionOutput> state) {
    return const InferenceIndicator(
        icon: icon,
        color: CupertinoColors.systemRed,
        type: type,
        message: "Error");
  }
}
