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

  @override
  List<Object> get props => [landmarks, depthPoints, visibilityPoints];
}
