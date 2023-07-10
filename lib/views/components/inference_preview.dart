import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import '../../bloc/inference/inference_bloc.dart';
import '../camera_painters/pose_painter.dart';

class InferencePreview extends StatefulWidget {
  const InferencePreview({
    required this.inferenceController,
    required this.cameraController,
    Key? key,
  }) : super(key: key);

  final InferenceBloc? inferenceController;
  final CameraController? cameraController;

  @override
  State<InferencePreview> createState() => InferencePreviewState();
}

class InferencePreviewState extends State<InferencePreview> {
  late double _ratio;
  //late final InferenceService inferenceService;

  late Map<String, dynamic>? results = {};

  @override
  void initState() {
    super.initState();

    //inferenceService = InferenceService();
    widget.cameraController!.startVideoRecording(
        onAvailable: (CameraImage image) {
      widget.inferenceController!.add(InferenceInput(input: image));

      if (mounted && widget.inferenceController?.state is InferenceDone) {
        setState(() =>
            results = widget.inferenceController?.aggregatedResponse ?? {});
      }
    });
  }

  @override
  void dispose() {
    //inferenceService.dispose();
    super.dispose();
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
            // _drawBoundingBox,
            // _drawLandmarks,
            // _drawHands,
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
