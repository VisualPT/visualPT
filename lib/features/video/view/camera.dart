import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class Camera extends StatelessWidget {
  const Camera({super.key, required this.controller, required this.children});
  final CameraController controller;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.previewSize!.height,
          height: controller.value.previewSize!.width,
          child: AspectRatio(
            aspectRatio: 1 / controller.value.aspectRatio,
            child: CameraPreview(
              controller,
              child: Stack(fit: StackFit.expand, children: children),
            ),
          ),
        ),
      ),
    );
  }
}
