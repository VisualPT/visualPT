import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/video/video_bloc.dart';
import 'package:visualpt/inference/pose/pose_service.dart';
import 'package:visualpt/views/components/_components.dart';
import '../bloc/inference/inference_bloc.dart';
import '../views/camera_painters/pose_painter.dart';

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
    return SafeArea(
        left: false,
        right: false,
        child: CameraPreview(videoState.controller,
            child: response != null
                ? response.heightThreshold
                    ? _drawPose(response.landmarks)
                    : const Text("Get closer!")
                : const Text("Keep subject in frame!")));
  }

  Widget onStopped(BuildContext context, InferenceStopped state) {
    return SafeArea(
        left: false, right: false, child: CameraPreview(videoState.controller));
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

  // Widget get _drawBoundingBox {
  //   final bbox = results?['bbox'];
  //   return _ModelPainter(
  //     customPainter: FaceDetectionPainter(
  //       bbox: bbox ?? Rect.zero,
  //       ratio: _ratio,
  //     ),
  //   );
  // }

  // Widget get _drawLandmarks => _ModelPainter(
  //       customPainter: FaceMeshPainter(
  //         points: results?['face'] ?? [],
  //         ratio: _ratio,
  //       ),
  //     );

  // Widget get _drawHands => _ModelPainter(
  //       customPainter: HandsPainter(
  //         points: results?['hand'] ?? [],
  //         ratio: _ratio,
  //       ),
  //     );

  Widget _drawPose(List<Offset>? points) {
    return _ModelPainter(
      customPainter: PosePainter(
        points: points ?? [],
      ),
    );
  }
}

class _ModelPainter extends StatelessWidget {
  const _ModelPainter({
    required this.customPainter,
    Key? key,
  }) : super(key: key);

  final CustomPainter customPainter;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: customPainter,
    );
  }
}
