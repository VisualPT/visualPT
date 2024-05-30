import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/views/_views.dart';

// Widget get _drawBoundingBox {
//   final bbox = results?['bbox'];
//   return _ModelPainter(
//     customPainter: FaceDetectionPainter(
//       bbox: bbox ?? Rect.zero,
//       ratio: _ratio,
//     ),
//   );
// }

class FaceDetectionPainter extends CustomPainter {
  final Rect bbox;
  final double ratio;

  FaceDetectionPainter({
    required this.bbox,
    required this.ratio,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (bbox != Rect.zero) {
      var paint = Paint()
        ..color = Styles.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      canvas.drawRect(bbox, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
