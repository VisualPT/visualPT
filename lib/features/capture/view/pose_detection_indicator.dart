import 'package:flutter/cupertino.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/capture/service/pose_detection_output.dart';
import 'package:visualpt/features/capture/view/capture_indicator.dart';
import 'package:visualpt/models/ModelProvider.dart';

const double maxSwayAngle = 8;

class PoseDetectionIndicator extends StatelessWidget {
  const PoseDetectionIndicator(this.detection, {super.key});
  static const icon = CupertinoIcons.person;
  static const type = "Sway - Lateral/AP";

  final Detection? detection;
  @override
  Widget build(BuildContext context) {
    if (detection == null) {
      return const CaptureIndicator(
        icon: icon,
        color: Styles.red,
        type: type,
        child: Text("No data"),
      );
    }
    final angles = PoseDetection.computeAngles(detection!);

    final latColor =
        angles.$1.abs() < maxSwayAngle / 2 ? Styles.green : Styles.yellow;
    return CaptureIndicator(
      icon: icon,
      color: Styles.green,
      type: type,
      child: Text(
          "${angles.$1.toStringAsFixed(1)}° / ${angles.$2.toStringAsFixed(1)}°",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: latColor,
              fontSize: 22,
              fontFamily: 'monospace')),
    );
  }
}
