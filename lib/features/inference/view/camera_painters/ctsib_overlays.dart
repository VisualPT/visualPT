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
      ..color = Colors.blue.withAlpha(200) // Change this to the desired color
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

    // Center of top and bottom points
    final Offset tc = Offset(boxOffset + (boxWidth / 2), 0);
    final Offset bc = Offset(boxOffset + (boxWidth / 2), size.height);

    // Draw the box
    canvas.drawLine(tl, tr, paint); // top horizontal line
    canvas.drawLine(bl, br, paint); // bottom horizontal line
    canvas.drawLine(bl, tl, paint); // left angled line
    canvas.drawLine(br, tr, paint); // right angled line
    canvas.drawLine(bc, tc, paint); // center bisecting line
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Function to compute the line of best fit
// Returns a tuple where item1 is the slope (m) and item2 is the y-intercept (b) of the line y = mx + b
LineOfBestFit computeLineOfBestFit(List<Offset> points, Size size) {
  double sumX = 0,
      sumY = 0,
      sumY2 = 0,
      sumXY = 0,
      smallestY = double.infinity,
      largestY = double.negativeInfinity;
  int n = points.length;

  for (var point in points) {
    sumX += point.dx;
    sumY += point.dy;
    sumY2 += point.dy * point.dy;
    sumXY += point.dx * point.dy;
    if (point.dy < smallestY) {
      smallestY = point.dy;
    }
    if (point.dy > largestY) {
      largestY = point.dy;
    }
  }

  // Calculating slope (m) and y-intercept (b) for the line of best fit
  // m = (N Σ(xy) - Σx Σy) / (N Σ(x^2) - (Σx)^2)
  // b = Σy - m * Σx / N
  double slope = (n * sumXY - sumX * sumY) / (n * sumY2 - sumY * sumY);
  double yIntercept = (sumX - slope * sumY) / n;

  Offset top = Offset(smallestY * slope + yIntercept, smallestY);
  Offset bottom = Offset(largestY * slope + yIntercept, largestY);
  double degrees = atan(slope) * 180 / pi;
  return LineOfBestFit(top, bottom, degrees);
}

class PoseSway extends StatelessWidget {
  final List<Offset> points;
  const PoseSway({required this.points, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: Colors.red.withAlpha(50),
        child: CustomPaint(painter: PoseSwayPainter(points)),
      );
    });
  }
}

class PoseSwayPainter extends CustomPainter {
  final List<Offset>? points;
  const PoseSwayPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.orange.withAlpha(230) // Change this to the desired color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final offsets = points != null ? computeLineOfBestFit(points!, size) : null;
    if (offsets != null) {
      canvas.drawLine(offsets.low, offsets.high, paint);
      //TODO: STORE THE DEGREES OF THE IMAGE WITH THE IMAGE
      print(offsets.degrees);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Utility function to convert degrees to radians
double radians(double degrees) => degrees * pi / 180;

class LineOfBestFit {
  final Offset low;
  final Offset high;
  final double degrees;

  LineOfBestFit(this.low, this.high, this.degrees);
}
