import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import 'face_detection_painter.dart';
import 'face_mesh_painter.dart';
import 'hands_painter.dart';
import 'pose_painter.dart';

class ModelCameraPreview extends StatelessWidget {
  ModelCameraPreview({
    required this.cameraController,
    required this.draw,
    required this.results,
    Key? key,
  }) : super(key: key);

  final CameraController? cameraController;
  final bool draw;
  final Map<String, dynamic>? results;

  late final double _ratio;

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container(
        color: CupertinoColors.black,
        child: const Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }

    final screenSize = MediaQuery.of(context).size;
    _ratio = screenSize.width / cameraController!.value.previewSize!.height;

    return Stack(
      children: [
        CameraPreview(cameraController!),
        Visibility(
          visible: draw,
          child: Stack(
            children: [
              _drawBoundingBox,
              _drawLandmarks,
              _drawHands,
              _drawPose,
            ],
          ),
        ),
      ],
    );
  }

  Widget get _drawBoundingBox {
    final bbox = results?['bbox'];
    return _ModelPainter(
      customPainter: FaceDetectionPainter(
        bbox: bbox ?? Rect.zero,
        ratio: _ratio,
      ),
    );
  }

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
