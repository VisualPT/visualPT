import 'dart:math';
import 'package:flutter/material.dart';

const double MAX_SWAY_ANGLE = 12;

bool validateInequalities(
    double minA, double maxA, double minB, double maxB, double diff) {
  // Calculate ratios once
  double ratioMax = maxA / maxB;
  double ratioMin = minA / minB;
  double diffA = maxA - minA;
  double diffB = maxB - minB;
  double min = 1 - diff;
  double max = 1 + diff;

  // Avoid division by zero
  if (diffB == 0) return false; // Adjust based on the domain-specific needs
  double ratioDxDy = diffA / diffB;

  // Check each condition
  bool condition1 = min <= ratioMax && ratioMax <= max;
  bool condition2 = min <= ratioMin && ratioMin <= max;
  bool condition3 = min < ratioDxDy && ratioDxDy <= max;

  return condition1 && condition2 && condition3;
}

class PoseBbox extends StatelessWidget {
  final List<Offset>? points;
  const PoseBbox({this.points, super.key});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = Size(constraints.maxWidth, constraints.maxHeight);
      final boxHeight = constraints.maxHeight * 0.8;
      const aspectRatio = 1 / 3;

      final ratio = constraints.maxWidth / constraints.maxHeight;
      double bMinX = 0, bMaxX = 0, bMinY = 0, bMaxY = 0;
      if (ratio < aspectRatio) {
        throw Exception("This type of aspect ratio is not supported");
      } else {
        // If the height is the limiting side, we can use the full height to calculate BBox
        bMinY = size.height * 0.10;
        bMaxY = size.height * 0.90;
        var paintAreaWidth = (bMaxY - bMinY) * aspectRatio;
        var paintAreaMinX = (size.width - paintAreaWidth) / 2;
        var bboxWidth = paintAreaWidth * 0.69;
        bMinX = paintAreaMinX + (paintAreaWidth - bboxWidth) / 2;
        bMinX = (size.width - paintAreaWidth) / 2;
        bMaxX = bMinX + bboxWidth;
      }
      // Calculate the bounding box
      double? minX = points?.map((e) => e.dx).reduce(min);
      double? maxX = points?.map((e) => e.dx).reduce(max);
      double? minY = points?.map((e) => e.dy).reduce(min);
      double? maxY = points?.map((e) => e.dy).reduce(max);
      //Set color
      // Color color = Colors.blue;
      Color xColor = Colors.blue, yColor = Colors.blue;

      if (minX != null && maxX != null && minY != null && maxY != null) {
        final isWidthWithin20Percent =
            validateInequalities(minX, maxX, bMinX, bMaxX, 0.2);
        final isHeightWithin20Percent =
            validateInequalities(minY, maxY, bMinY, bMaxY, 0.2);
        final isWidthWithin40Percent =
            validateInequalities(minX, maxX, bMinX, bMaxX, 0.4);
        final isHeightWithin40Percent =
            validateInequalities(minY, maxY, bMinY, bMaxY, 0.4);

        xColor = isWidthWithin20Percent
            ? Colors.green
            : isWidthWithin40Percent
                ? Colors.yellow
                : Colors.red;
        yColor = isHeightWithin20Percent
            ? Colors.green
            : isHeightWithin40Percent
                ? Colors.yellow
                : Colors.red;
      }

      return Center(
          child: SizedBox(
              height: boxHeight,
              child: Center(
                  child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: CustomPaint(
                          painter: BoxPainter(
                        xColor: xColor,
                        yColor: yColor,
                      ))))));
    });
  }
}

class BoxPainter extends CustomPainter {
  final Color xColor;
  final Color yColor;
  const BoxPainter({
    this.xColor = Colors.blue,
    this.yColor = Colors.blue,
  });

  @override
  void paint(Canvas canvas, Size size) {
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

    final Paint xPaint = Paint()
      ..color = xColor.withAlpha(200)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final Paint yPaint = Paint()
      ..color = yColor.withAlpha(200)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final Paint paint = Paint()
      ..color = Colors.blue.withAlpha(200)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // //Draw the computed box
    // canvas.drawRect(
    //     Rect.fromPoints(Offset(0, 0), Offset(bBox["maxX"], bBox["maxY"])),
    //     paint);

    // Draw the box
    canvas.drawLine(tl, tr, yPaint); // top horizontal line
    canvas.drawLine(bl, br, yPaint); // bottom horizontal line
    canvas.drawLine(bl, tl, xPaint); // left angled line
    canvas.drawLine(br, tr, xPaint); // right angled line
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
    final offsets = points != null ? computeLineOfBestFit(points!, size) : null;
    final color = offsets != null
        ? offsets.degrees.abs() < MAX_SWAY_ANGLE
            ? Colors.green
            : Colors.yellow
        : Colors.red; // Change this to the desired color
    final Paint paint = Paint()
      ..color = color.withAlpha(230) // Change this to the desired color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    if (offsets != null) {
      canvas.drawLine(offsets.low, offsets.high, paint);
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
