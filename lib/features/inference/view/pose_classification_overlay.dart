import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt_collector/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt_collector/features/inference/service/pose_classification/pose_class_output.dart';
import 'package:visualpt_collector/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt_collector/features/inference/view/inference_presenter.dart';

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
    return Stack(
      alignment: Alignment.bottomCenter,
      fit: StackFit.expand,
      children: [
        state.response != null
            ? ColoredBox(color: getColorFromValue(state.response?.getValue()))
            : Positioned(
                bottom: 0,
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  child:
                      const Text("Testing the Balance class with the gradient"),
                ),
              ),
      ],
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

Color getColorFromValue(double? value) {
  if (value == null) return CupertinoColors.systemYellow.withOpacity(0.5);

  // Calculate the red and green components based on the value
  // Assuming a simple linear interpolation: red decreases and green increases with the value
  int red = (255 * (1 - value)).round();
  int green = (255 * value).round();

  // Return the color
  return Color.fromARGB(255, red, green, 0).withOpacity(0.2);
}
