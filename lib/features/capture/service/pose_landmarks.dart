import 'dart:convert';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:visualpt/models/ModelProvider.dart';

// ignore: must_be_immutable
class PoseLandmarks extends Equatable {
  PoseLandmarks(this.output) {
    poseLandmarks = parseLandmarks(
        output['poseLandmarks'], computeZScale(output['poseLandmarks']));
    worldLandmarks = parseLandmarks(
        output['worldLandmarks'], computeZScale(output['worldLandmarks']));
  }

  final Map<String, dynamic> output;
  late List<(double, double, double, double)> poseLandmarks;
  late List<(double, double, double, double)> worldLandmarks;

  // Define constants for excluding landmarks
  static List<int> excludeForXY = [
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, // Face landmarks
    13, 14, // Elbows
    15, 16, 17, 18, 19, 20, 21, 22, // Hands
  ];

  static List<int> excludeForYZ = [
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, // Face landmarks
    13, 14, // Elbows
    15, 16, 17, 18, 19, 20, 21, 22, // Hands
    27, 28, 29, 30, 31, 32 // Feet
  ];

  List<(double, double, double, double)> parseLandmarks(
      List<dynamic> landmarks, double zScale) {
    return landmarks
        .map((landmark) => (
              landmark['x'] as double,
              landmark['y'] as double,
              ((landmark['z'] as double) - getMinZ(landmarks)) * zScale +
                  getMinX(landmarks),
              landmark['visibility'] as double
            ))
        .toList();
  }

  /// Computes the appropriate Z scaling factor based on the range of X and Z values
  double computeZScale(List<dynamic> landmarks) {
    if (landmarks.isEmpty) return 1.0;

    double xRange = getMaxX(landmarks) - getMinX(landmarks);
    double zRange = getMaxZ(landmarks) - getMinZ(landmarks);

    return (zRange > 0)
        ? (xRange / zRange)
        : 1.0; // Default to 1 if zRange is zero
  }

  double getMinX(List<dynamic> landmarks) =>
      landmarks.map((l) => l['x'] as double).reduce(min);
  double getMaxX(List<dynamic> landmarks) =>
      landmarks.map((l) => l['x'] as double).reduce(max);
  double getMinZ(List<dynamic> landmarks) =>
      landmarks.map((l) => l['z'] as double).reduce(min);
  double getMaxZ(List<dynamic> landmarks) =>
      landmarks.map((l) => l['z'] as double).reduce(max);

  /// Encodes the PoseLandmarks object into a JSON string
  String encode() {
    final encoded = {
      'poseLandmarks':
          poseLandmarks.map((l) => [l.$1, l.$2, l.$3, l.$4]).toList(),
      'worldLandmarks':
          worldLandmarks.map((l) => [l.$1, l.$2, l.$3, l.$4]).toList(),
    };
    return jsonEncode(encoded);
  }

  /// Decodes a JSON string and applies the appropriate Z scaling
  static Map<String, List<(double, double, double, double)>> decode(
      String input) {
    final Map<String, dynamic> decoded = jsonDecode(input);

    final Map<String, List<(double, double, double, double)>> output = {
      'poseLandmarks': [],
      'worldLandmarks': [],
    };

    for (var landmark in decoded['poseLandmarks']) {
      output['poseLandmarks']
          ?.add((landmark[0], landmark[1], landmark[2], landmark[3]));
    }

    for (var landmark in decoded['worldLandmarks']) {
      output['worldLandmarks']
          ?.add((landmark[0], landmark[1], landmark[2], landmark[3]));
    }

    return output;
  }

  @override
  String toString() {
    return encode();
  }

  /// Compute body angles for a given detection.
  /// `type` can be `'lsq'` or `'lrg'`
  static (double, double) computeAngles(Detection detection) {
    final points = decode(detection.keypoints)['worldLandmarks'] ?? [];
    if (points.isEmpty) return (0.0, 0.0);

    final accelData = AccelerometerEvent(
        detection.env.accX,
        detection.env.accY,
        detection.env.accZ,
        detection.env.timestamp.getDateTimeInUtc().toLocal());

    // // --- Step 1: Compute Hip Center and Rotation Angle ---
    // final leftHip = points[23];
    // final rightHip = points[24];

    // double hipCenterX = (leftHip.$1 + rightHip.$1) / 2;
    // double hipCenterZ = (leftHip.$3 + rightHip.$3) / 2;
    // double deltaX = rightHip.$1 - leftHip.$1;
    // double deltaZ = rightHip.$3 - leftHip.$3;
    // double theta = atan2(deltaZ, deltaX); // Rotation angle

    // // --- Step 2: Rotate All Points to Align Hips Forward ---
    // List<(double, double, double, double)> rotatedPoints = points.map((point) {
    //   double x = point.$1 - hipCenterX;
    //   double z = point.$3 - hipCenterZ;
    //   double newX = x * cos(-theta) - z * sin(-theta);
    //   double newZ = x * sin(-theta) + z * cos(-theta);
    //   return (newX + hipCenterX, point.$2, newZ + hipCenterZ, point.$4);
    // }).toList();

    // --- Step 3: Filter Points Based on Exclusions ---
    final filteredPointsXY = points
        .asMap()
        .entries
        .where((entry) => !excludeForXY.contains(entry.key))
        .map((entry) => entry.value)
        .toList();

    final filteredPointsYZ = points
        .asMap()
        .entries
        .where((entry) => !excludeForYZ.contains(entry.key))
        .map((entry) => entry.value)
        .toList();

    // --- Step 4: Compute Angles Using Reusable Function ---
    double degreesXY = _computeSlopeDegreesLstsq(filteredPointsXY, 1, 2);
    double degreesYZ = _computeSlopeDegreesLstsq(filteredPointsYZ, 2, 3);

    // --- Step 5: Adjust for Pitch (Device Tilt Compensation) ---
    final pitch = (atan2(-accelData.x,
                sqrt(accelData.y * accelData.y + accelData.z * accelData.z)) *
            (180 / pi))
        .abs();
    degreesXY = (degreesXY - pitch).abs();

    return (degreesXY, degreesYZ);
  }

  /// Compute slope in degrees for a given set of points.
  /// Uses least squares regression for stability.
  static double _computeSlopeDegreesLstsq(
      List<(double, double, double, double)> points, int axis1, int axis2) {
    int n = points.length;
    if (n < 2) return 0.0; // Avoid division by zero

    double sumA = 0, sumB = 0, sumAB = 0, sumB2 = 0;

    for (var point in points) {
      double a = (axis1 == 1) ? point.$1 : point.$3; // X or Z
      double b = point.$2; // Y
      sumA += a;
      sumB += b;
      sumAB += a * b;
      sumB2 += b * b;
    }

    if (sumB2 == 0) return 0.0;
    double slope = (n * sumAB - sumA * sumB) / (n * sumB2 - sumB * sumB);
    return (atan(slope) * 180 / pi); // Convert to degrees
  }

  @override
  List<Object> get props => [output];
}
