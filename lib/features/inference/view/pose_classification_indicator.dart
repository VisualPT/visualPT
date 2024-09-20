import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/views/_views.dart';
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
      onStandby: onStandby,
      onLoad: onLoad,
      onError: onError,
    );
  }

  Widget onRunning(BuildContext context,
      InferenceRunning<PoseDetectionOutput, PoseClassificationOutput> state) {
    return InferenceIndicator(
      icon: icon,
      color: Styles.green,
      type: type,
      message: "Running",
      formattedTextWidget: Text(state.response?.name ?? "No subject",
          style: TextStyle(
              color: state.response?.getColor() ?? Styles.red,
              fontSize: 22,
              fontFamily: 'monospace')),
    );
  }

  Widget onStandby(BuildContext context,
      InferenceStandby<PoseDetectionOutput, PoseClassificationOutput> state) {
    return const InferenceIndicator(
        icon: icon, color: Styles.yellow, type: type, message: "Standby");
  }

  Widget onLoad(BuildContext context,
      InferenceLoading<PoseDetectionOutput, PoseClassificationOutput> state) {
    return const InferenceIndicator(
        icon: icon, color: Styles.inactiveGray, type: type, message: "Loading");
  }

  Widget onError(BuildContext context,
      InferenceError<PoseDetectionOutput, PoseClassificationOutput> state) {
    return const InferenceIndicator(
        icon: icon, color: Styles.errorRed, type: type, message: "Error");
  }
}
