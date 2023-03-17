import 'package:flutter/cupertino.dart';

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
        ..color = CupertinoColors.activeBlue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      canvas.drawRect(bbox, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
