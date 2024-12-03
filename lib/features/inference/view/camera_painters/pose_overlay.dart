import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/views/_views.dart';

class PoseOverlay extends StatelessWidget {
  final List<Offset>? points;
  const PoseOverlay({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PosePainter(
        rawPoints: points ?? [],
      ),
    );
  }
}

class PosePainter extends CustomPainter {
  final List<Offset> rawPoints;

  PosePainter({
    required this.rawPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final points = rawPoints
        .map((p) =>
            Offset(p.dx * (size.width / 255), p.dy * (size.height / 255)))
        .toList();
    if (points.isNotEmpty) {
      var pointPaint = Paint()
        ..color = Styles.blue
        ..strokeWidth = 2;
      var headPaint = Paint()
        ..color = Styles.yellow
        ..strokeWidth = 1;
      var leftPaint = Paint()
        ..color = Styles.mint
        ..strokeWidth = 1;
      var rightPaint = Paint()
        ..color = Styles.mint
        ..strokeWidth = 1;
      var bodyPaint = Paint()
        ..color = Styles.mint
        ..strokeWidth = 1;

      canvas.drawPoints(
        PointMode.points,
        points.sublist(0, 34).toList(),
        pointPaint,
      );

      canvas.drawPoints(
        PointMode.polygon,
        [
          points[8],
          points[6],
          points[5],
          points[4],
          points[0],
          points[1],
          points[2],
          points[3],
          points[7],
        ].toList(),
        headPaint,
      );
      canvas.drawPoints(
        PointMode.polygon,
        [
          points[10],
          points[9],
        ].toList(),
        headPaint,
      );

      canvas.drawPoints(
        PointMode.polygon,
        [
          points[12],
          points[14],
          points[16],
          points[18],
          points[20],
          points[16],
        ].toList(),
        leftPaint,
      );
      canvas.drawPoints(
        PointMode.polygon,
        [
          points[16],
          points[22],
        ].toList(),
        leftPaint,
      );
      canvas.drawPoints(
        PointMode.polygon,
        [
          points[24],
          points[26],
          points[28],
          points[32],
          points[30],
          points[28],
        ].toList(),
        leftPaint,
      );

      canvas.drawPoints(
        PointMode.polygon,
        [
          points[11],
          points[13],
          points[15],
          points[17],
          points[19],
          points[15],
        ].toList(),
        rightPaint,
      );
      canvas.drawPoints(
        PointMode.polygon,
        [
          points[15],
          points[21],
        ].toList(),
        rightPaint,
      );
      canvas.drawPoints(
        PointMode.polygon,
        [
          points[23],
          points[25],
          points[27],
          points[29],
          points[31],
          points[27],
        ].toList(),
        rightPaint,
      );

      canvas.drawPoints(
        PointMode.polygon,
        [
          points[11],
          points[12],
          points[24],
          points[23],
          points[11],
        ].toList(),
        bodyPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
