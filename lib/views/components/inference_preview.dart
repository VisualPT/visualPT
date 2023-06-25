//import 'dart:developer';

import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import '../../service/inference_service.dart';
import '../camera_painters/pose_painter.dart';

class InferencePreview extends StatefulWidget {
  const InferencePreview({
    required this.inferenceService,
    required this.cameraController,
    Key? key,
  }) : super(key: key);
  final InferenceService inferenceService;
  final CameraController? cameraController;

  @override
  State<InferencePreview> createState() => InferencePreviewState();
}

class InferencePreviewState extends State<InferencePreview> {
  late double _ratio;

  late List<Offset> results = [];

  @override
  void initState() {
    super.initState();

    try {
      widget.cameraController!.startVideoRecording(onAvailable: (image) async {
        final data = await widget.inferenceService.getPoseDetection(image);
        if (mounted && data is List<Offset> && data.isNotEmpty) {
          setState(
            () => results = data,
          );
        }
      });
    } catch (e) {
      log("An error occured in the Inference Preview $e");
    }
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
          points: results,
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
