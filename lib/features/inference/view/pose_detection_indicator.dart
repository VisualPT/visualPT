import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/inference/view/inference_indicator.dart';
import 'package:visualpt/features/inference/view/inference_presenter.dart';

class PoseDetectionIndicator extends StatelessWidget {
  const PoseDetectionIndicator({super.key});
  static const icon = CupertinoIcons.person;
  static const type = "Pose Detection";

  @override
  Widget build(BuildContext context) {
    return InferencePresenter<CameraImage, PoseDetectionOutput>(
      onRunning: onRunning,
      onStandby: onStandby,
      onLoad: onLoad,
      onError: onError,
    );
  }

  Widget onRunning(BuildContext context,
      InferenceRunning<CameraImage, PoseDetectionOutput> state) {
    return const InferenceIndicator(
        icon: icon,
        color: CupertinoColors.activeGreen,
        type: type,
        message: "Running");
  }

  Widget onStandby(BuildContext context,
      InferenceStandby<CameraImage, PoseDetectionOutput> state) {
    return const InferenceIndicator(
        icon: icon,
        color: CupertinoColors.systemYellow,
        type: type,
        message: "Standby");
  }

  Widget onLoad(BuildContext context,
      InferenceLoading<CameraImage, PoseDetectionOutput> state) {
    return const InferenceIndicator(
        icon: icon,
        color: CupertinoColors.systemGrey,
        type: type,
        message: "Loading");
  }

  Widget onError(BuildContext context,
      InferenceError<CameraImage, PoseDetectionOutput> state) {
    return const InferenceIndicator(
        icon: icon,
        color: CupertinoColors.systemRed,
        type: type,
        message: "Error");
  }
}
