import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/view/camera_painters/pose_bbox.dart';
import 'package:visualpt/features/inference/view/camera_painters/pose_overlay.dart';
import 'package:visualpt/features/inference/service/pose/pose_service.dart';
import 'package:visualpt/features/video/bloc/video_bloc.dart';
import 'package:visualpt/core/views/components/_components.dart';

class InferencePresenter extends StatelessWidget {
  const InferencePresenter({
    required this.videoState,
    Key? key,
  }) : super(key: key);
  final VideoRecording videoState;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InferenceBloc, InferenceState>(
      builder: (context, state) {
        try {
          return switch (state) {
            InferenceRunning() => onRunning(context, state),
            InferenceStopped() => onStopped(context, state),
            InferenceLoading() => onLoad(context, state),
            InferenceError() => onError(context, state),
            InferenceState() =>
              throw Exception("Inference State: ${state.toString()}"),
          };
        } catch (e) {
          return onError(context, InferenceError(error: Exception(e)));
        }
      },
    );
  }

  Widget onRunning(BuildContext context, InferenceRunning state) {
    final response = state.response as PoseOutput?;
    return AspectRatio(
      aspectRatio: 1 / videoState.controller.value.aspectRatio,
      child: CameraPreview(videoState.controller,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const PoseBbox(),
              response != null
                  ? response.heightThreshold
                      ? PoseOverlay(points: response.landmarks)
                      : const Center(child: Text("Get closer!"))
                  : const Center(child: Text("Keep subject in frame!"))
            ],
          )),
    );
  }

  Widget onStopped(BuildContext context, InferenceStopped state) {
    return const Center(
      child: AppLoading(message: "Inference Stopped"),
    );
  }

  Widget onLoad(BuildContext context, InferenceLoading state) {
    return const Center(
      child: AppLoading(message: "Loading Model"),
    );
  }

  Widget onError(BuildContext context, InferenceError state) {
    return const Center(
      child: Text("Inference Error"),
    );
  }
}
