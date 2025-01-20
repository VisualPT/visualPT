import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/video/bloc/video_bloc.dart';

class Camera extends StatelessWidget {
  const Camera({super.key, required this.controller, required this.children});
  final CameraController controller;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final vid = BlocProvider.of<VideoBloc>(context);
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
              child: LayoutBuilder(builder: (context, constraints) {
                return GestureDetector(
                    onTapDown: (details) => vid.add(VideoFocus(
                        localPosition: details.localPosition,
                        constraints: constraints)),
                    child: Stack(fit: StackFit.expand, children: children));
              }),
            ),
          ),
        ),
      ),
    );
  }
}
