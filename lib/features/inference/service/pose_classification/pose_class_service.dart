import 'dart:developer';

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:visualpt/features/inference/service/pose_classification/pose_class_output.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';

import '../../constants/model_file.dart';
import '../ai_model.dart';

const Map<int, String> classifications = {
  0: "static",
  1: "arms uncrossed",
  2: "trunk flex",
  3: "feet separated",
  -1: "invalid",
};

class NormConst {
  static const double meanMaxX = 148.9316624640058;
  static const double meanMaxY = 218.3240010129572;
  static const double meanMinX = 102.51440336306322;
  static const double meanMinY = 48.208955628623634;
  static const double maxX = 257.3079833984375;
  static const double maxY = 274.50079345703125;
  static const double minX = -4.650461196899414;
  static const double minY = -2.4850502014160156;
  static const List<double> center = [194.46347425, 192.89205381];
  static const List<double> distXY = [22.34033741, 0.91201126];
  static const double distAbsoluteXY = 22.373311160212694;
  static const List<List<double>> centers = [
    [172.12313683600976, 191.98004254546555],
    [194.46347424701685, 192.89205381036996],
    [216.80381165802393, 193.80406507527437]
  ];
  static const List<double> sds = [
    10.666145181421614,
    13.742566405833044,
    12.633746248003606,
    15.850760792503975,
    15.914418021459383
  ];
  static const double z = 1.9599639845400536;

  const NormConst();
}

class PoseClassification
    extends AiModel<PoseDetectionOutput, PoseClassificationOutput> {
  PoseClassification({super.interpreter}) {
    loadModel();
  }
  // static const int inputSize = 256;
  // static const double threshold = 0.70;

  @override
  List<Object> get props => [];

  @override
  int get getAddress => interpreter!.address;

  @override
  Future<void> loadModel() async {
    try {
      final interpreterOptions = InterpreterOptions();

      interpreter ??= await Interpreter.fromAsset(ModelFile.poseClassification,
          options: interpreterOptions);

      final inputTensors = interpreter!.getInputTensors();
      for (var tensor in inputTensors) {
        inputShapes.add(tensor.shape);
        inputTypes.add(tensor.type);
      }

      final outputTensors = interpreter!.getOutputTensors();
      for (var tensor in outputTensors) {
        outputShapes.add(tensor.shape);
        outputTypes.add(tensor.type);
      }
    } catch (e) {
      log('Error while creating interpreter: $e');
    }
  }

  @override
  PoseClassificationOutput? predict(
      String id, PoseDetectionOutput input, Map<String, dynamic>? params) {
    if (interpreter == null) {
      log('Interpreter not initialized');
      return null;
    }
    final List<List<double>> data = input.output;
    final processedInput =
        data.sublist(0, 33).map((e) => e.sublist(0, 2)).toList();

    final normalizedInput = normalizeDetection(processedInput);
    if (normalizedInput == null) {
      return null;
    }
    final inputs = [normalizedInput as Object];

    TensorBuffer output = TensorBufferFloat(outputShapes[0]);

    final outputs = <int, Object>{
      0: output.buffer,
    };

    interpreter!.runForMultipleInputs(inputs, outputs);

    final prediction = output.getDoubleList();
    return PoseClassificationOutput(input.id, prediction);
  }
}

PoseClassificationOutput? runPoseClassifier(Map<String, dynamic> params) {
  final pose = PoseClassification(
      interpreter: Interpreter.fromAddress(params['detectorAddress']));
  return pose.predict(params['id'], params['input'], params['params']);
}

List<List<double>>? normalizeDetection(List<List<double>> dataPoint) {
  // Assuming 'dataPoint' is a List<List<double>> where each inner list has 5 elements.
  if (dataPoint.length < 25) {
    return null;
  }

  // Find the center
  var icenter = [
    (dataPoint[23][0] + dataPoint[24][0]) / 2,
    (dataPoint[23][1] + dataPoint[24][1]) / 2
  ];

  // Find max and min
  var dMax = dataPoint.reduce((curr, next) => List.generate(
        curr.length,
        (index) => curr[index] > next[index] ? curr[index] : next[index],
      ));
  var dMin = dataPoint.reduce((curr, next) => List.generate(
        curr.length,
        (index) => curr[index] < next[index] ? curr[index] : next[index],
      ));

  var xmax = dMax[0];
  var ymax = dMax[1];
  var xmin = dMin[0];
  var ymin = dMin[1];

  var idistx = (dataPoint[23][0] - dataPoint[24][0]).abs();

  // Check for bad data
  bool isBad = xmax > NormConst.meanMaxX + (NormConst.z * NormConst.sds[0]) ||
      xmax < NormConst.meanMaxX - (NormConst.z * NormConst.sds[0]) ||
      ymax > NormConst.meanMaxY + (NormConst.z * NormConst.sds[1]) ||
      ymax < NormConst.meanMaxY - (NormConst.z * NormConst.sds[1]) ||
      xmin > NormConst.meanMinX + (NormConst.z * NormConst.sds[2]) ||
      xmin < NormConst.meanMinX - (NormConst.z * NormConst.sds[2]) ||
      ymin > NormConst.meanMinY + (NormConst.z * NormConst.sds[3]) ||
      ymin < NormConst.meanMinY - (NormConst.z * NormConst.sds[3]) ||
      idistx > NormConst.distXY[0] + (NormConst.z * NormConst.sds[4]) ||
      idistx < NormConst.distXY[0] - (NormConst.sds[4]);

  if (isBad) {
    print('Bad data');
    //TODO: We let all the data pass through to inference to keep the UI running even if the input is bad.
    // return null;
  }

  // Scale and translate data
  var scalex =
      NormConst.distXY[0] * 2 / (dataPoint[23][0] - dataPoint[24][0]).abs();
  var scaley = NormConst.meanMaxY / ymax;

  icenter = [
    (scalex * dataPoint[23][0] + scalex * dataPoint[24][0]) / 2,
    (scaley * dataPoint[23][1] + scaley * dataPoint[24][1]) / 2
  ];
  var idif = [
    NormConst.center[0] - icenter[0],
    NormConst.center[1] - icenter[1]
  ];

  List<List<double>> normalizedData = [];
  for (var point in dataPoint) {
    normalizedData.add([
      point[0] * scalex + idif[0],
      point[1] * scaley + idif[1],
    ]);
  }

  return normalizedData;
}
