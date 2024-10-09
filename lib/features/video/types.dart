import 'package:visualpt/features/assessment/types.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';

const VPTDetectionRate = 30;
const VPTClassificationRate = 1;

class DeviceMeta {
  final num deviceAcceleroX;
  final num deviceAcceleroY;
  final num deviceAcceleroZ;
  final num deviceGyroX;
  final num deviceGyroY;
  final num deviceGyroZ;

  const DeviceMeta(
    this.deviceAcceleroX,
    this.deviceAcceleroY,
    this.deviceAcceleroZ,
    this.deviceGyroX,
    this.deviceGyroY,
    this.deviceGyroZ,
  );

  String csv() {
    return "$deviceAcceleroX,$deviceAcceleroY,$deviceAcceleroZ,$deviceGyroX,$deviceGyroY,$deviceGyroZ";
  }
}

class VPTDetection {
  final int version;
  final String id;
  //Image Meta
  final int imageHeight;
  final int imageWidth;
  //Clinical Meta
  final TrialMeta assessmentMeta;
  //Detection Meta
  final DeviceMeta deviceMeta;
  final String inferredClassification;
  //Detection Data
  final PoseDetectionOutput output;

  const VPTDetection(
    this.version,
    this.id,
    this.imageHeight,
    this.imageWidth,
    this.assessmentMeta,
    this.deviceMeta,
    this.inferredClassification,
    this.output,
  );

  // Formats the object into a string
  //
  // ==================
  // <Version>\n
  // <Image Meta>\n
  // <Clinical Meta>\n
  // <Detection Meta>\n
  // <Detection Data>
  // ==================
  String toCSV() {
    return "$version\n"
        "$id\n"
        "$imageHeight,$imageWidth\n"
        "${assessmentMeta.csv()}\n"
        "${deviceMeta.csv()},$inferredClassification\n"
        "${output.output.map((keypoint) => keypoint.join(",")).join("\n")}";
  }

  static VPTDetection fromCSV(String dataOutput) {
    final lines = dataOutput.split("\n");
    final version = int.parse(lines.removeAt(0));
    final id = lines.removeAt(0);
    final imageMeta = lines.removeAt(0).split(",");
    final assessmentMeta = TrialMeta.fromCSV(lines.removeAt(0));
    final deviceMeta = lines.removeAt(0).split(",");
    final inferredClassification = deviceMeta.removeLast();
    final output = PoseDetectionOutput(
      id,
      lines
          .map((line) => line.split(",").map((e) => double.parse(e)).toList())
          .toList(),
    );
    return VPTDetection(
      version,
      id,
      int.parse(imageMeta[0]),
      int.parse(imageMeta[1]),
      assessmentMeta,
      DeviceMeta(
        double.parse(deviceMeta[0]),
        double.parse(deviceMeta[1]),
        double.parse(deviceMeta[2]),
        double.parse(deviceMeta[3]),
        double.parse(deviceMeta[4]),
        double.parse(deviceMeta[5]),
      ),
      inferredClassification,
      output,
    );
  }

  VPTDetection copyWith({required String inferredClassification}) {
    return VPTDetection(
      version,
      id,
      imageHeight,
      imageWidth,
      assessmentMeta,
      deviceMeta,
      inferredClassification,
      output,
    );
  }
}

class VPTDetectionV0 {
  //Image Meta
  final int imageHeight;
  final int imageWidth;
  final double ratio;
  final bool classification;
  //Detection Data
  final PoseDetectionOutput detection;
  VPTDetectionV0(
    this.imageHeight,
    this.imageWidth,
    this.ratio,
    this.classification,
    this.detection,
  );

  static fromCSV(String id, String dataOutput) {
    final imageMetadata = dataOutput.split('\n').first.split(',');

    final imageHeight = int.parse(imageMetadata.elementAt(0));
    final imageWidth = int.parse(imageMetadata.elementAt(1));
    final ratio = double.parse(imageMetadata.elementAt(2));
    final classification =
        int.parse(imageMetadata.elementAt(3)) == 1 ? true : false;

    final detection = dataOutput.substring(dataOutput.indexOf('\n'));

    final output = PoseDetectionOutput(id, detection);
    return VPTDetectionV0(
        imageHeight, imageWidth, ratio, classification, output);
  }
}

parseVersionedDetection(String id, String dataOutput) {
  final version = int.parse(dataOutput.split('\n').first);
  if (version == 1) {
    return VPTDetection.fromCSV(dataOutput);
  } else {
    return VPTDetectionV0.fromCSV(id, dataOutput);
  }
}
