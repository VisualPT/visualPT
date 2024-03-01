import 'dart:ui';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_service.dart';

List<Offset> parsePoseOffsets(String input, double height, double width) {
  const inputSize = PoseDetection.inputSize;
  // Split the input by lines
  var lines = input.split('\n');
  lines.removeWhere((element) => element.isEmpty);

  // Map each line to an Offset and collect to a list
  var offsets = lines.map((line) {
    var values = line.split(',');
    var x = double.parse(values[0]);
    var y = double.parse(values[1]);
    return Offset(x / inputSize * width, y / inputSize * height);
  }).toList();

  return offsets;
}
