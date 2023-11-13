import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_classification/pose_class_output.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/inference/view/inference_presenter.dart';

class PoseClassificationOverlay extends StatelessWidget {
  const PoseClassificationOverlay({super.key, required this.controller});
  final CameraController controller;

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
    print("PoseClassificationOverlay: onRunning: ${state.response.toString()}");
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [Text(state.response.toString())],
    );
  }

  Widget onStandby(BuildContext context,
      InferenceStandby<PoseDetectionOutput, PoseClassificationOutput> state) {
    return Container();
  }

  Widget onLoad(BuildContext context,
      InferenceLoading<PoseDetectionOutput, PoseClassificationOutput> state) {
    return Container();
  }

  Widget onError(BuildContext context,
      InferenceError<PoseDetectionOutput, PoseClassificationOutput> state) {
    return Container();
  }
}
