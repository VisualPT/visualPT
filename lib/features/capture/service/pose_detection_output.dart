import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:visualpt/models/ModelProvider.dart';

// ignore: must_be_immutable
class PoseDetection extends Equatable {
  PoseDetection(this.id, this.output) {
    for (var point in output) {
      final double dx = point[0];
      final double dy = point[1];
      landmarks.add(Offset(dx, dy));
      depthPoints.add(point[2]);
      visibilityPoints.add(point[3]);
      presencePoints.add(point[4]);
    }
  }
  final String id;
  final List<List<double>> output;

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

  @override
  String toString() {
    return jsonEncode(output);
  }

  static List<(double, double, double, double)> fromString(String input) {
    final List<dynamic> decoded = jsonDecode(input);

    // Convert each dynamic element into a List<(double, double, double, double)>
    final List<(double, double, double, double)> output = decoded
        .map((dynamic innerList) {
          // Ensure that innerList is a List<dynamic> and cast each element to double
          return (innerList as List<(double, double, double, double)>)
              .map((dynamic item) => item as double)
              .toList();
        })
        .cast<(double, double, double, double)>()
        .toList();
    return output;
  }

  //Computes the latitudidal (left/right (x,y)) and longitudidal (y, z) angles of the pose
  //longitudinal angle is based on synthetic data, so it is not accurate and should not be used until further testing is done
  static (double, double) computeAngles(Detection detection) {
    //TODO: verify the data is stable enough
    // * Nothing super outliery in the data

    // It should ignore the head landmarks and only consider the body landmarks (10-33)
    final points = decodeKeypoints(detection.keypoints).sublist(10, 33);
    final accelData = AccelerometerEvent(
        detection.env.accX,
        detection.env.accY,
        detection.env.accZ,
        detection.env.timestamp.getDateTimeInUtc().toLocal());

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
    // It should ignore the head landmarks and only consider the body landmarks (10-33)
    points = points.sublist(10, 33);
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

  static String encodeKeypoints(Map<String, dynamic> keypoints) {
    //TODO: Try with world landmarks
    return jsonEncode(keypoints['poseLandmarks'].map((landmark) {
      return [
        landmark['x'],
        landmark['y'],
        landmark['z'],
        landmark['visibility']
      ];
    }).toList());
  }

  static List<(double, double, double, double)> decodeKeypoints(
      String keypoints) {
    // Convert JSON string back to a list of tuples
    print(keypoints);
    return (jsonDecode(keypoints) as List<dynamic>)
        .map((e) => (
              e[0] as double,
              e[1] as double,
              e[2] as double,
              e[3] as double,
            ))
        .toList();
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
