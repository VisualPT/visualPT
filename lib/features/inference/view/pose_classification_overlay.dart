import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_classification/pose_class_output.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/inference/view/camera_painters/pose_bbox.dart';
import 'package:visualpt/features/inference/view/inference_presenter.dart';

class PoseClassificationOverlay extends StatelessWidget {
  const PoseClassificationOverlay({super.key, required this.controller});
  final CameraController controller;

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
    //final response = state.response;
    return const Stack(
      fit: StackFit.expand,
      children: [PoseBbox()],
    );
  }

  Widget onStopped(BuildContext context,
      InferenceStopped<PoseDetectionOutput, PoseClassificationOutput> state) {
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
