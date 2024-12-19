import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:sensors_plus/sensors_plus.dart';
import 'package:visualpt/features/inference/service/ai_model.dart';
import 'package:visualpt/features/inference/service/depth_detection/depth_detection_output.dart';

// ignore: must_be_immutable
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
  late List<double> depthPoints = [];
  final List<double> visibilityPoints = [];
  final List<double> presencePoints = [];
  late AccelerometerEvent? accelData;

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

  //Updates the depth points with the new depth points
  updateDepth(DepthDetectionOutput depthOutput) {
    //For each landmark, find the closest depth point and update the depth point
    for (int i = 0; i < landmarks.length; i++) {
      final landmark = landmarks[i];
      final depthPoint = depthOutput.output[landmark.dx.round().clamp(0, 255)]
          [landmark.dy.round().clamp(0, 255)];
      depthPoints[i] = depthPoint;
      output[i][2] = depthPoint;
    }
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

//Computes the latitudidal (left/right (x,y)) and longitudidal (y, z) angles of the pose
//longitudinal angle is based on synthetic data, so it is not accurate and should not be used until further testing is done
  static (double, double) computeAngles(
      List<(double, double, double)> points, AccelerometerEvent accelData) {
    // It should ignore the head landmarks and only consider the body landmarks (10-34)
    points = points.sublist(10, 34);
    double sumX = 0,
        sumY = 0,
        sumZ = 0,
        sumY2 = 0,
        sumXY = 0,
        sumYZ = 0,
        sumZ2 = 0,
        smallestY = double.infinity,
        largestY = double.negativeInfinity,
        smallestX = double.infinity,
        largestX = double.negativeInfinity,
        smallestZ = double.infinity,
        largestZ = double.negativeInfinity;

    int n = points.length;

    for (var point in points) {
      sumX += point.$1;
      sumY += point.$2;
      sumZ += point.$3;
      sumY2 += point.$2 * point.$2;
      sumXY += point.$1 * point.$2;
      sumYZ += point.$2 * point.$3;
      sumZ2 += point.$3 * point.$3;
      if (point.$2 < smallestY) {
        smallestY = point.$2;
      }
      if (point.$2 > largestY) {
        largestY = point.$2;
      }
      if (point.$1 < smallestX) {
        smallestX = point.$1;
      }
      if (point.$1 > largestX) {
        largestX = point.$1;
      }
      if (point.$3 < smallestZ) {
        smallestZ = point.$3;
      }
      if (point.$3 > largestZ) {
        largestZ = point.$3;
      }
    }
    double slopeXY = (n * sumXY - sumX * sumY) / (n * sumY2 - sumY * sumY);
    double slopeYZ = (n * sumYZ - sumY * sumZ) / (n * sumZ2 - sumZ * sumZ);

    double degreesXY = (atan(slopeXY) * 180 / pi).abs();
    double degreesYZ = (atan(slopeYZ) * 180 / pi).abs();

    //Factor the roll and pitch into the angles
    // final roll =
    //     (atan2(accelData.y, accelData.z) * (180 / pi)).abs(); // Roll in degrees
    final pitch = (atan2(-accelData.x,
                sqrt(accelData.y * accelData.y + accelData.z * accelData.z)) *
            (180 / pi))
        .abs(); // Pitch in degrees
    degreesXY = (degreesXY - pitch).abs();
    // degreesYZ = (degreesYZ - roll).abs(); //TODO: this has not been tested

    return (degreesXY, degreesYZ);
  }

  // Function to compute the line of best fit
  // Returns a tuple where item1 is the slope (m) and item2 is the y-intercept (b) of the line y = mx + b
  static LineOfBestFit computeLineOfBestFit(
      List<Offset> points, Size size, AccelerometerEvent accelData) {
    // It should ignore the head landmarks and only consider the body landmarks (10-34)
    points = points.sublist(10, 34);
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

    //Factor the pitch into the angles
    final pitch = (atan2(-accelData.x,
                sqrt(accelData.y * accelData.y + accelData.z * accelData.z)) *
            (180 / pi))
        .abs(); // Pitch in degrees

    //Find the difference between the pitch and the angle of the line of best fit.
    // Addition is used to account for the fact that the pitch is negative
    degrees = (degrees - pitch).abs();

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
