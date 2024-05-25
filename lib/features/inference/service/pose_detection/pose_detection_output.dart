import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:visualpt/features/inference/service/ai_model.dart';

class PoseDetectionOutput extends AiModelOutput {
  PoseDetectionOutput(super.id, super.output) {
    for (var point in output) {
      final double dx = point[0];
      final double dy = point[1];
      landmarks.add(Offset(dx, dy));
      depthPoints.add(point[2]);
      visibilityPoints.add(point[3]);
      presencePoints.add(point[4]);
    }
  }

  static const length = 33;
  final List<Offset> landmarks = [];
  final List<double> depthPoints = [];
  final List<double> visibilityPoints = [];
  final List<double> presencePoints = [];

  bool exceedsHeightThreshold(height) {
    return landmarks.fold(0.0, (prev, o) => max(prev, o.dy)) -
            landmarks.fold(double.infinity, (prev, o) => min(prev, o.dy)) >
        (height * 0.5);
  }

  toMap() {
    return {
      'landmarkPoints': landmarks,
      'depthPoints': depthPoints,
      'visibilityPoints': visibilityPoints,
      'presencePoints': presencePoints,
    };
  }

  toRaw() {
    return output;
  }

  @override
  String toString() {
    final o = output as List<List<double>>;
    return jsonEncode(o);
  }

  static List<List<double>> fromString(String input) {
    final List<dynamic> decoded = jsonDecode(input);

    // Convert each dynamic element into a List<double>
    final List<List<double>> output = decoded.map((dynamic innerList) {
      // Ensure that innerList is a List<dynamic> and cast each element to double
      return (innerList as List<dynamic>)
          .map((dynamic item) => item as double)
          .toList();
    }).toList();
    return output;
  }

  static double computeAngle(List<Offset> points) {
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
    double slope = (n * sumXY - sumX * sumY) / (n * sumY2 - sumY * sumY);

    double degrees = (atan(slope) * 180 / pi).abs();
    return degrees;
  }

// Function to compute the line of best fit
// Returns a tuple where item1 is the slope (m) and item2 is the y-intercept (b) of the line y = mx + b
  static LineOfBestFit computeLineOfBestFit(List<Offset> points, Size size) {
    double sumX = 0,
        sumY = 0,
        sumY2 = 0,
        sumXY = 0,
        smallestY = double.infinity,
        largestY = double.negativeInfinity;
    int n = points.length;

    for (var p in points) {
      final point = p.scale(size.width / 255, size.height / 255);
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
    double xIntercept = (sumX - slope * sumY) / n;

    Offset top = Offset(smallestY * slope + xIntercept, smallestY);
    Offset bottom = Offset(largestY * slope + xIntercept, largestY);
    double degrees = (atan(slope) * 180 / pi).abs();
    return LineOfBestFit(top, bottom, degrees);
  }

  @override
  List<Object> get props => [landmarks, depthPoints, visibilityPoints];
}

class LineOfBestFit {
  final Offset low;
  final Offset high;
  final double degrees;

  LineOfBestFit(this.low, this.high, this.degrees);
}
