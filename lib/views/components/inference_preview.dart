import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/service/inference_service.dart';

import '../camera_painters/face_detection_painter.dart';
import '../camera_painters/face_mesh_painter.dart';
import '../camera_painters/hands_painter.dart';
import '../camera_painters/pose_painter.dart';

class InferencePreview extends StatefulWidget {
  const InferencePreview({
    required this.cameraController,
    Key? key,
  }) : super(key: key);

  final CameraController? cameraController;

  @override
  State<InferencePreview> createState() => InferencePreviewState();
}

class InferencePreviewState extends State<InferencePreview> {
  late double _ratio;
  late final InferenceService inferenceService;

  late Map<String, dynamic>? results = {};

  @override
  void initState() {
    super.initState();

    inferenceService = InferenceService();
    widget.cameraController!
        .startVideoRecording(onAvailable: (CameraImage image) {});
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    _ratio =
        screenSize.width / widget.cameraController!.value.previewSize!.height;
    if (widget.cameraController == null ||
        !widget.cameraController!.value.isInitialized ||
        results == null) {
      return Container(
        color: CupertinoColors.black,
        child: const Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }

    return Stack(
      children: [
        CameraPreview(widget.cameraController!),
        Stack(
          children: [
            //_drawBoundingBox,
            _drawLandmarks,
            _drawHands,
            _drawPose,
          ],
        )
      ],
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

  Widget get _drawLandmarks => _ModelPainter(
        customPainter: FaceMeshPainter(
          points: results?['face'] ?? [],
          ratio: _ratio,
        ),
      );

  Widget get _drawHands => _ModelPainter(
        customPainter: HandsPainter(
          points: results?['hand'] ?? [],
          ratio: _ratio,
        ),
      );

  Widget get _drawPose => _ModelPainter(
        customPainter: PosePainter(
          points: results?['pose'] ?? [],
          ratio: _ratio,
        ),
      );
}

class _ModelPainter extends StatelessWidget {
  _ModelPainter({
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
