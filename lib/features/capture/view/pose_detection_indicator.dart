import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/capture/service/pose_landmarks.dart';
import 'package:visualpt/features/capture/view/capture_indicator.dart';
import 'package:visualpt/models/ModelProvider.dart';

const double warnLatSwayAngle = 4;
const double warnAPSwayAngle = 4;
const double maxLatSwayAngle = 8;
const double maxAPSwayAngle = 8;

class PoseLandmarksIndicator extends StatelessWidget {
  const PoseLandmarksIndicator(this.detection, {this.message, super.key});
  static const icon = CupertinoIcons.person;
  static const type = "Sway - Lat/AP";

  final String? message;
  final Detection? detection;
  @override
  Widget build(BuildContext context) {
    if (detection == null) {
      return CaptureIndicator(
          icon: icon,
          color: Styles.red,
          type: type,
          child: Text(message ?? "No Detection",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: message != null ? Styles.black : Styles.red,
                fontSize: 24,
                fontFamily: 'monospace',
              )));
    }

    final angles = PoseLandmarks.computeAngles(detection!);

    final latColor = angles.$1.abs() < warnLatSwayAngle
        ? Styles.green
        : angles.$1.abs() < maxLatSwayAngle
            ? Styles.yellow
            : Styles.red;
    final apColor = angles.$2.abs() < maxAPSwayAngle / 2
        ? Styles.green
        : angles.$2.abs() < maxAPSwayAngle
            ? Styles.yellow
            : Styles.red;

    return Column(
      children: [
        CaptureIndicator(
          icon: icon,
          color: Styles.green,
          type: type,
          child: Row(
            children: [
              Text("${angles.$1.round()}°",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: latColor,
                      fontSize: 24,
                      fontFamily: 'monospace',
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 0),
                          blurRadius: 5.0,
                          color: Styles.black,
                        ),
                      ])),
              const Text(" / ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontFamily: 'monospace',
                  )),
              Text("${angles.$2.round()}°",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: apColor,
                      fontSize: 24,
                      fontFamily: 'monospace',
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 0),
                          blurRadius: 5.0,
                          color: Styles.black,
                        ),
                      ])),
            ],
          ),
        ),
      ],
    );
  }
}
