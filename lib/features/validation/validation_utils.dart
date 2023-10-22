import 'dart:ui';
import 'package:helpers/helpers.dart';
import 'package:visualpt/features/inference/service/pose/pose_service.dart';

List<Offset> parsePoseOffsets(String input, double height, double width) {
  const inputSize = Pose.inputSize;
  // Split the input by lines
  var lines = input.split('\n').removeNulls();
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
