import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/inference/pose/pose_service.dart';
import 'package:visualpt/views/styles.dart';
import '../../bloc/inference/inference_bloc.dart';
import '../camera_painters/pose_painter.dart';

class InferencePainter extends StatefulWidget {
  const InferencePainter({
    required this.inferenceController,
    required this.cameraController,
    required this.isRecording,
    Key? key,
  }) : super(key: key);

  final InferenceBloc? inferenceController;
  final CameraController? cameraController;
  final bool isRecording;
  @override
  State<InferencePainter> createState() => InferencePainterState();
}

class InferencePainterState extends State<InferencePainter> {
  Timer? timer;
  late double _ratio;
  bool classification = true;
  List<Offset>? results = [];

  @override
  void initState() {
    super.initState();
    widget.cameraController!.startVideoRecording(
        onAvailable: (CameraImage image) {
      if (mounted && widget.isRecording && widget.inferenceController != null) {
        widget.inferenceController!.add(InferenceInput(input: image));
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
        !widget.cameraController!.value.isInitialized) {
      return Container(
        color: CupertinoColors.black,
        child: const Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }

    return BlocBuilder<InferenceBloc, InferenceState>(
      builder: (context, state) {
        print(state);
        final response = state.response as PoseOutput?;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (response != null) {
            setState(() {
              results = response.landmarks;
            });
          }
        });
        return Stack(children: [
          CameraPreview(widget.cameraController!),
          // _drawBoundingBox,
          // _drawLandmarks,
          // _drawHands,
          _drawPose(results),
          widget.isRecording
              ? Stack(children: [
                  Center(
                    child: Text(results.toString(),
                        style: const TextStyle(
                            color: CupertinoColors.white, fontSize: 4)),
                  ),
                  Positioned(
                    bottom: 100,
                    child: Container(
                      color: CupertinoColors.black.withOpacity(0.5),
                      width: screenSize.width,
                      child: Column(
                        children: [
                          Text(
                              "Current Classification: ${classification ? "Static" : "Sway"}",
                              style: Styles.subactionText),
                          Row(
                            children: [
                              const Spacer(),
                              CupertinoSwitch(
                                  value: classification,
                                  onChanged: (c) =>
                                      setState(() => classification = c)),
                              const Spacer()
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ])
              : Container()
        ]);
      },
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
        ratio: _ratio,
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
