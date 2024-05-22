import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/inference/view/camera_painters/ctsib_overlays.dart';
import 'package:visualpt/features/inference/view/inference_indicator.dart';
import 'package:visualpt/features/inference/view/inference_presenter.dart';
import 'package:visualpt/models/ModelProvider.dart';

class DeviceCapture extends Identifiable {
  final CameraImage input;
  final DetectionEnv measurements;
  const DeviceCapture(super.id, this.input, this.measurements);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceCapture &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => "DeviceCapture{id: $id}";

  @override //the props
  List<Object> get props => [id];
}

class PoseDetectionIndicator extends StatelessWidget {
  const PoseDetectionIndicator({super.key});
  static const icon = CupertinoIcons.person;
  static const type = "Pose Detection";

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
      InferenceStandby<DeviceCapture, PoseDetectionOutput> state) {
    return const InferenceIndicator(
        icon: icon,
        color: CupertinoColors.systemYellow,
        type: type,
        message: "Standby");
  }

  Widget onLoad(BuildContext context,
      InferenceLoading<DeviceCapture, PoseDetectionOutput> state) {
    return const InferenceIndicator(
        icon: icon,
        color: CupertinoColors.systemGrey,
        type: type,
        message: "Loading");
  }

  Widget onError(BuildContext context,
      InferenceError<DeviceCapture, PoseDetectionOutput> state) {
    return const InferenceIndicator(
        icon: icon,
        color: CupertinoColors.systemRed,
        type: type,
        message: "Error");
  }
}
