import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/_views.dart';

class VideoTimer extends StatelessWidget {
  final CameraController cameraController;
  final Duration duration;
  const VideoTimer(
      {super.key, required this.cameraController, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Text(formatter(duration), style: Styles.timerTextStyle);
  }
}

String formatter(Duration duration) => [
      duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
      duration.inMilliseconds.remainder(1000).toString().padLeft(3, '0')[0]
    ].join(".");
