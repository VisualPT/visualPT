import 'dart:typed_data';
import 'dart:ui';

import 'package:image/image.dart' as i;

class ValidationData {
  late final i.Image image;
  late final int classification;
  late final List<Offset> offsets;
  ValidationData(Uint8List imageBytes, String detectionPayload) {
    var lines = detectionPayload.split("\n"),
        metadata = lines[0].split(','),
        height = int.parse(metadata[0]),
        width = int.parse(metadata[1]),
        detectionData = detectionPayload.replaceRange(
            0, detectionPayload.indexOf('\n'), '');
    classification = int.parse(metadata[2]);
    image = i.Image.fromBytes(width, height, imageBytes);
    offsets = parseOffsets(detectionData);
  }
}

List<Offset> parseOffsets(String input) {
  // Split the input by lines
  var lines = input.split('\n');

  // Map each line to an Offset and collect to a list
  var offsets = lines.map((line) {
    var values = line.split(',');
    var x = double.parse(values[0]);
    var y = double.parse(values[1]);
    return Offset(x, y);
  }).toList();

  return offsets;
}
