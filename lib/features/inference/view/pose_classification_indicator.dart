import 'package:flutter/cupertino.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_classification/pose_class_output.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/inference/view/inference_indicator.dart';
import 'package:visualpt/features/inference/view/inference_presenter.dart';

class PoseClassificationIndicator extends StatelessWidget {
  const PoseClassificationIndicator({super.key});
  static const icon = CupertinoIcons.arrow_branch;
  static const type = "Pose Classification";

  @override
  Widget build(BuildContext context) {
    return InferencePresenter<PoseDetectionOutput, PoseClassificationOutput>(
      onRunning: onRunning,
      onStopped: onStopped,
      onLoad: onLoad,
      onError: onError,
    );
  }

  Widget onRunning(BuildContext context,
      InferenceRunning<PoseDetectionOutput, PoseClassificationOutput> state) {
    return const InferenceIndicator(
        icon: icon,
        color: CupertinoColors.white,
        type: type,
        message: "Running");
  }

  Widget onStopped(BuildContext context,
      InferenceStopped<PoseDetectionOutput, PoseClassificationOutput> state) {
    return const InferenceIndicator(
        icon: icon,
        color: CupertinoColors.systemYellow,
        type: type,
        message: "Stopped");
  }

  Widget onLoad(BuildContext context,
      InferenceLoading<PoseDetectionOutput, PoseClassificationOutput> state) {
    return const InferenceIndicator(
        icon: icon,
        color: CupertinoColors.systemGrey,
        type: type,
        message: "Loading");
  }

  Widget onError(BuildContext context,
      InferenceError<PoseDetectionOutput, PoseClassificationOutput> state) {
    return const InferenceIndicator(
        icon: icon,
        color: CupertinoColors.systemRed,
        type: type,
        message: "Error");
  }
}
