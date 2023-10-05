import 'dart:math';
import 'package:flutter/material.dart';

class PoseBbox extends StatelessWidget {
  const PoseBbox({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final height = constraints.maxHeight * 0.8;
      const aspectRatio = 1 / 3;
      return Center(
          child: SizedBox(
              height: height,
              child: Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: CustomPaint(painter: BoxPainter()),
                ),
              )));
    });
  }
}

class BoxPainter extends CustomPainter {
  BoxPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue // Change this to the desired color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Define bottom width of the box
    final double boxWidth = 0.69 * size.width;
    final double boxOffset = (size.width - boxWidth) / 2;

    // Calculate the horizontal offset for the angled sides
    final double xOffset = boxWidth * tan(radians(12));

    // Bottom left and right points
    final Offset bl = Offset(boxOffset + 0, size.height);
    final Offset br = Offset(boxOffset + boxWidth, size.height);

    // Top left and right points considering the angle
    final Offset tl = Offset(boxOffset + -xOffset, 0);
    final Offset tr = Offset(boxOffset + boxWidth + xOffset, 0);

    // Draw the box
    canvas.drawLine(tl, tr, paint); // top horizontal line
    canvas.drawLine(bl, br, paint); // bottom horizontal line
    canvas.drawLine(bl, tl, paint); // left angled line
    canvas.drawLine(br, tr, paint); // right angled line
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Utility function to convert degrees to radians
double radians(double degrees) => degrees * pi / 180;
