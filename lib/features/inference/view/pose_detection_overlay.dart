import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/inference/view/camera_painters/pose_bbox.dart';
import 'package:visualpt/features/inference/view/camera_painters/pose_overlay.dart';
import 'package:visualpt/features/inference/view/inference_presenter.dart';

class PoseDetectionOverlay extends StatelessWidget {
  const PoseDetectionOverlay({super.key, required this.controller});
  final CameraController controller;

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
    final response = state.response;
    //TODO: put this into a better place
    if (state.response != null) {
      //TODOV1  BlocProvider.of< InferenceBloc<PoseDetectionOutput, PoseClassificationOutput>>( context).inferenceRepository.add(state.response!);
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        const PoseBbox(),
        response != null
            ? response.heightThreshold
                ? PoseOverlay(points: response.landmarks)
                : const Center(child: Text("Get closer!"))
            : const Center(child: Text("Keep subject in frame!"))
      ],
    );
  }

  Widget onStandby(BuildContext context,
      InferenceStandby<CameraImage, PoseDetectionOutput> state) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        PoseBbox(),
      ],
    );
    ;
  }

  Widget onLoad(BuildContext context,
      InferenceLoading<CameraImage, PoseDetectionOutput> state) {
    return Container();
  }

  Widget onError(BuildContext context,
      InferenceError<CameraImage, PoseDetectionOutput> state) {
    return Container();
  }
}
