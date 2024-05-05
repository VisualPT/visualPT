import 'dart:ui';

import 'package:visualpt/features/inference/service/ai_model.dart';

class PoseDetectionOutput extends AiModelOutput {
  PoseDetectionOutput(super.output, int inputSize, int width, int height) {
    const double percentOfImageHeightThreshold = 0.5;

    double min = height.roundToDouble(), max = 0;

    for (var point in output) {
      final double dx = point[0];
      final double dy = point[1];
      if (dy < min) {
        min = dy;
      }
      if (dy > max) {
        max = dy;
      }
      landmarks.add(Offset(dx, dy));
      depthPoints.add(point[2]);
      visibilityPoints.add(point[3]);
      presencePoints.add(point[4]);
    }
    heightThreshold = max - min > (height * percentOfImageHeightThreshold);
  }

  static const length = 33;
  final List<Offset> landmarks = [];
  final List<double> depthPoints = [];
  final List<double> visibilityPoints = [];
  final List<double> presencePoints = [];
  bool heightThreshold = false;

  toMap() {
    return {
      'landmarkPoints': landmarks,
      'depthPoints': depthPoints,
      'visibilityPoints': visibilityPoints,
      'presencePoints': presencePoints,
      'heightThreshold': heightThreshold,
    };
  }

  toRaw() {
    return output;
  }

  @override
  List<Object> get props => [landmarks, depthPoints, visibilityPoints];
}
