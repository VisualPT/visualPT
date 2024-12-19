import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:visualpt/core/views/_views.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/inference/view/camera_painters/ctsib_overlays.dart';
import 'package:visualpt/features/video/view/capture_indicator.dart';
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
  static const type = "Pose Detection (Lateral/AP Sway)";

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
    final points = (state.response?.output as List<List<double>>)
        .map<(double, double, double)>((e) => (e[0], e[1], e[2]))
        .toList();
    final angles = PoseDetectionOutput.computeAngles(
        points,
        state.response?.accelData ??
            AccelerometerEvent(0, 0, 0, DateTime.now()));

    final latColor =
        angles.$1.abs() < MAX_SWAY_ANGLE / 2 ? Styles.green : Styles.yellow;
    // final apColor =
    //     angles.$2.abs() < MAX_SWAY_ANGLE / 2 ? Styles.green : Styles.yellow;
    return CaptureIndicator(
      icon: icon,
      color: Styles.green,
      type: type,
      child: Text(
          "${angles.$1.toStringAsFixed(1)}° / ${angles.$2.toStringAsFixed(1)}°",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: latColor,
              fontSize: 22,
              fontFamily: 'monospace')),
    );
  }

  Widget onStandby(BuildContext context,
      InferenceStandby<DeviceCapture, PoseDetectionOutput> state) {
    return const CaptureIndicator(
        icon: icon,
        color: Styles.yellow,
        type: type,
        child: Text("Standby",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Styles.black,
                fontSize: 22,
                fontFamily: 'monospace')));
  }

  Widget onLoad(BuildContext context,
      InferenceLoading<DeviceCapture, PoseDetectionOutput> state) {
    return const CaptureIndicator(
      icon: icon,
      color: Styles.inactiveGray,
      type: type,
      child: Text("Loading",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Styles.black,
              fontSize: 22,
              fontFamily: 'monospace')),
    );
  }

  Widget onError(BuildContext context,
      InferenceError<DeviceCapture, PoseDetectionOutput> state) {
    return const CaptureIndicator(
      icon: icon,
      color: Styles.errorRed,
      type: type,
      child: Text("Error",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Styles.black,
              fontSize: 22,
              fontFamily: 'monospace')),
    );
  }
}
