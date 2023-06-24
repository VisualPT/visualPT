import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import '../../service/inference_service.dart';
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

  late Map<String, dynamic>? results = {};

  @override
  void initState() {
    super.initState();

    widget.cameraController!.startVideoRecording(
        onAvailable: (CameraImage image) {
      final data = InferenceService.getPoseDetection(image);
      log("data: $data");
    });
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
            _drawPose,
          ],
        )
      ],
    );
  }

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
