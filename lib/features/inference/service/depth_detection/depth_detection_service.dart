import 'dart:developer';

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:visualpt/features/inference/service/depth_detection/depth_detection_output.dart';

import '../../constants/model_file.dart';
import '../ai_model.dart';

class DepthDetection extends AiModel<TensorImage, DepthDetectionOutput> {
  DepthDetection({super.interpreter}) {
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

      interpreter ??= await Interpreter.fromAsset(ModelFile.depthDetection,
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
  DepthDetectionOutput? predict(
      String id, TensorImage input, Map<String, dynamic>? params) {
    if (interpreter == null) {
      log('Interpreter not initialized');
      return null;
    }

    TensorBuffer output = TensorBufferFloat(outputShapes[0]);

    final inputs = <Object>[input.buffer];

    final outputs = <int, Object>{
      0: output.buffer,
    };

    interpreter!.runForMultipleInputs(inputs, outputs);

    final depthDetection = output.getDoubleList().reshape<double>([256, 256])
        as List<List<double>>;

    return DepthDetectionOutput(id, depthDetection);
  }
}

DepthDetectionOutput? runDepthDetector(Map<String, dynamic> params) {
  final depth = DepthDetection(
      interpreter: Interpreter.fromAddress(params['detectorAddress']));
  return depth.predict(params['id'], params['input'], params['params']);
}
