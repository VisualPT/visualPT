import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphify/graphify.dart';
import 'package:visualpt/features/capture/service/pose_landmarks.dart';
import 'package:visualpt/models/ModelProvider.dart';

class PoseChartAnalysis extends StatefulWidget {
  final List<Detection> detections;

  const PoseChartAnalysis({super.key, required this.detections});

  @override
  State<PoseChartAnalysis> createState() => _PoseChartAnalysisState();
}

class _PoseChartAnalysisState extends State<PoseChartAnalysis> {
  late final GraphifyController controller;
  late final List<List<double>> fullData;
  List<double> animatedData = [];
  Timer? animationTimer;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = GraphifyController();
    fullData = _encodeDataset();

    _startAnimation();
  }

  List<List<double>> _encodeDataset() {
    final points = <List<double>>[];
    for (final detection in widget.detections) {
      final landmarks = PoseLandmarks.decode(detection.keypoints);
      for (final landmark in landmarks) {
        points.add([landmark.$1, landmark.$2, landmark.$3]);
      }
    }
    return points;
  }

  void _startAnimation() {
    animationTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (currentIndex < fullData.length) {
        setState(() {
          animatedData = fullData[currentIndex];
          currentIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    animationTimer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      child: GraphifyView(
        controller: controller,
        initialOptions: {
          'grid3D': const {},
          'xAxis3D': const {},
          'yAxis3D': const {},
          'zAxis3D': const {},
          'animation': true,
          'dataset': {'source': animatedData},
          'series': const [
            {
              'type': 'scatter3D',
              'symbolSize': 3,
              'encode': {
                'x': 0,
                'y': 1,
                'z': 2,
              }
            }
          ],
        },
      ),
    );
  }
}
