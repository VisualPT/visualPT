import 'dart:convert';
import 'dart:math';

import 'package:archive/archive.dart';
import 'package:equatable/equatable.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:visualpt/features/assessment/types.dart';
import 'package:visualpt/models/CameraDirection.dart';
import 'package:visualpt/models/Detection.dart';

// ignore: must_be_immutable
class PoseLandmarks extends Equatable {
  PoseLandmarks(this.output) {
    worldLandmarks = parseLandmarks(output['worldLandmarks']['coordinates'],
        computeZScale(output['worldLandmarks']['coordinates']));
  }

  final Map<String, dynamic> output;
  late List<(double, double, double, double)> worldLandmarks;

  // Define constants for excluding landmarks
  static List<int> excludeForXY = [
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, // Face landmarks
    13, 14, // Elbows
    15, 16, 17, 18, 19, 20, 21, 22, // Hands
    29, 30, 31, 32 //Feet
  ];

  static List<int> excludeForYZ = [
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, // Face landmarks
    13, 14, // Elbows
    15, 16, 17, 18, 19, 20, 21, 22, // Hands
    27, 28, // Ankles
    29, 30, 31, 32 // Feet
  ];

  List<(double, double, double, double)> parseLandmarks(
      Map<String, dynamic> landmarks, double zScale) {
    return landmarks.entries.map((entry) {
      final landmark = entry.value;
      return (
        landmark['x'] as double,
        landmark['y'] as double,
        ((landmark['z'] as double) - getMinZ(landmarks)) * zScale +
            getMinX(landmarks),
        landmark['visibility'] as double
      );
    }).toList();
  }

  double computeZScale(Map<String, dynamic> landmarks) {
    if (landmarks.isEmpty) return 1.0;
    double xRange = getMaxX(landmarks) - getMinX(landmarks);
    double zRange = getMaxZ(landmarks) - getMinZ(landmarks);
    return (zRange > 0) ? (xRange / zRange) : 1.0;
  }

  double getMinX(Map<String, dynamic> landmarks) =>
      landmarks.values.map((l) => l['x'] as double).reduce(min);
  double getMaxX(Map<String, dynamic> landmarks) =>
      landmarks.values.map((l) => l['x'] as double).reduce(max);
  double getMinZ(Map<String, dynamic> landmarks) =>
      landmarks.values.map((l) => l['z'] as double).reduce(min);
  double getMaxZ(Map<String, dynamic> landmarks) =>
      landmarks.values.map((l) => l['z'] as double).reduce(max);

  String encode() {
    final encoded = {
      'worldLandmarks': worldLandmarks
          .map((l) => _roundLandmark([l.$1, l.$2, l.$3, l.$4]))
          .toList(),
    };
    return jsonEncode(encoded);
  }

  List<double> _roundLandmark(List<double> l, {int precision = 3}) {
    double scale = pow(10, precision).toDouble();
    return l.map((v) => (v * scale).round() / scale).toList();
  }

  static List<(double, double, double, double)> decode(String input) {
    final Map<String, dynamic> decoded = jsonDecode(input);
    return (decoded['worldLandmarks'] as List)
        .map((landmark) => (
              landmark[0] as double,
              landmark[1] as double,
              landmark[2] as double,
              landmark[3] as double
            ))
        .toList();
  }

  @override
  String toString() {
    return encode();
  }

  static (double, double) computeAngles(
    Detection detection, {
    DetectionParams params = const DetectionParams(),
  }) {
    // Decode keypoints from the stored string format
    final decodedKeypoints = PoseLandmarks.decode(detection.keypoints);
    final points = decodedKeypoints; // List of (x, y, z, visibility)

    if (points.isEmpty) return (0.0, 0.0);

    // Extract accelerometer data
    final accelData = AccelerometerEvent(
        detection.env.accX,
        detection.env.accY,
        detection.env.accZ,
        detection.env.timestamp.getDateTimeInUtc().toLocal());

    // Filter keypoints based on exclusion lists
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

    // Compute angles using least squares regression
    double degreesXY = _computeSlopeDegreesLstsq(filteredPointsXY, 1, 2);
    double degreesYZ = _computeSlopeDegreesLstsq(filteredPointsYZ, 2, 3);

    // Account for the camera direction
    if (detection.direction == CameraDirection.BACK) {
      degreesYZ = -degreesYZ;
    } else if (detection.direction == CameraDirection.FRONT) {
      degreesXY = -degreesXY;
    }

    // Apply pitch and yaw adjustments using accelerometer data if required
    if (params.deviceCorrection) {
      final pitch = (atan2(-accelData.x,
              sqrt(accelData.y * accelData.y + accelData.z * accelData.z)) *
          (180 / pi));

      final yaw = (accelData.y != 0)
          ? (atan(accelData.z / accelData.y) * (180 / pi))
          : 0;

      degreesXY -= pitch;
      degreesYZ -= yaw;
    }

    // Always apply sensitivity and offset
    degreesXY = (degreesXY + params.offset.$1) * params.sensitivity.$1;
    degreesYZ = (degreesYZ + params.offset.$2) * params.sensitivity.$2;

    return (degreesXY, degreesYZ);
  }

  static double _computeSlopeDegreesLstsq(
      List<(double, double, double, double)> points, int axis1, int axis2) {
    int n = points.length;
    if (n < 2) return 0.0;

    double sumA = 0, sumB = 0, sumAB = 0, sumB2 = 0;

    for (var point in points) {
      double a = (axis1 == 1) ? point.$1 : point.$3;
      double b = point.$2;
      sumA += a;
      sumB += b;
      sumAB += a * b;
      sumB2 += b * b;
    }

    if (sumB2 == 0) return 0.0;
    double slope = (n * sumAB - sumA * sumB) / (n * sumB2 - sumB * sumB);
    return (atan(slope) * 180 / pi);
  }

  static String encodeCompressed(List<Detection> detections) {
    final json = jsonEncode(detections.map((d) => d.toJson()).toList());
    final compressed = const GZipEncoder().encode(utf8.encode(json));
    return base64Encode(compressed);
  }

  static List<Detection> decodeCompressed(String compressedString) {
    final compressed = base64Decode(compressedString);
    final decompressed = const GZipDecoder().decodeBytes(compressed);
    final decodedJson = jsonDecode(utf8.decode(decompressed)) as List<dynamic>;
    return decodedJson.map((e) => Detection.fromJson(e)).toList();
  }

  @override
  List<Object> get props => [output];
}
