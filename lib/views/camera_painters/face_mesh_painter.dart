import 'dart:ui';

import 'package:flutter/cupertino.dart';

class FaceMeshPainter extends CustomPainter {
  final List<Offset> points;
  final double ratio;

  FaceMeshPainter({
    required this.points,
    required this.ratio,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isNotEmpty) {
      var paint1 = Paint()
        ..color = CupertinoColors.activeGreen
        ..strokeWidth = 4;

      canvas.drawPoints(PointMode.points,
          points.map((point) => point * ratio).toList(), paint1);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
