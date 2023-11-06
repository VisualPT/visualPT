import 'dart:developer';

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:visualpt/features/inference/service/pose_classification/pose_class_output.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';

import '../../constants/model_file.dart';
import '../ai_model.dart';

const Map<int, String> classifications = {
  -1: "invalid",
  0: "static",
  1: "arms uncrossed",
  2: "trunk flex",
  3: "feet separated",
};

// ignore: must_be_immutable
class PoseClassification
    extends AiModel<PoseDetectionOutput, PoseClassificationOutput> {
  PoseClassification({super.interpreter}) {
    loadModel();
  }
  static const int inputSize = 256;
  static const double threshold = 0.70;

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
      PoseDetectionOutput input, Map<String, dynamic> params) {
    if (interpreter == null) {
      log('Interpreter not initialized');
      return null;
    }
    final processedInput =
        input.output.sublist(0, 33).map((e) => e.sublist(0, 2)).toList();
    final inputs = <Object>[processedInput];

    TensorBuffer output = TensorBufferFloat(outputShapes[0]);

    final outputs = <int, Object>{
      0: output.buffer,
    };

    interpreter!.runForMultipleInputs(inputs, outputs);

    final prediction = output.getDoubleValue(0);
    print(prediction);
    return PoseClassificationOutput(prediction);

    // //TODO: there are 33 landmarks, why is there 39 defined here?
    // final landmarkPoints = outputLandmarks
    //     .getIntValue()
    //     .reshape<double>([39, 5]) as List<List<double>>;

    // final ratio = params['ratio'] as double;

    // return PoseClassificationOutput(
    //     []);
  }
}

PoseClassificationOutput? runPoseClassifier(Map<String, dynamic> params) {
  final pose = PoseClassification(
      interpreter: Interpreter.fromAddress(params['detectorAddress']));
  final result = pose.predict(params['input'], params['params']);
  return result;
}
