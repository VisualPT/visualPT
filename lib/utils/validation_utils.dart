import 'dart:ui';
import 'package:helpers/helpers.dart';

List<Offset> parseOffsets(String input) {
  // Split the input by lines
  var lines = input.split('\n').removeNulls();
  lines.removeWhere((element) => element.isEmpty);

  // Map each line to an Offset and collect to a list
  var offsets = lines.map((line) {
    var values = line.split(',');
    var x = double.parse(values[0]);
    var y = double.parse(values[1]);
    return Offset(x, y);
  }).toList();

  return offsets;
}
