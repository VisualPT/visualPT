import 'dart:developer';

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';

import '../../constants/model_file.dart';
import '../ai_model.dart';

// ignore: must_be_immutable
class PoseDetection extends AiModel<TensorImage, PoseDetectionOutput> {
  PoseDetection({super.interpreter}) {
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

      interpreter ??= await Interpreter.fromAsset(ModelFile.poseDetection,
          options: interpreterOptions);

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
  PoseDetectionOutput? predict(
      String id, TensorImage input, Map<String, dynamic>? params) {
    if (interpreter == null) {
      log('Interpreter not initialized');
      return null;
    }

    // if (Platform.isAndroid) {
    //   image = image_lib.copyRotate(image, -90);
    //   image = image_lib.flipHorizontal(image);
    // }

    TensorBuffer outputLandmarks = TensorBufferFloat(outputShapes[0]);
    TensorBuffer outputIdentity1 = TensorBufferFloat(outputShapes[1]);
    TensorBuffer outputIdentity2 = TensorBufferFloat(outputShapes[2]);
    TensorBuffer outputIdentity3 = TensorBufferFloat(outputShapes[3]);
    TensorBuffer outputIdentity4 = TensorBufferFloat(outputShapes[4]);

    final inputs = <Object>[input.buffer];

    final outputs = <int, Object>{
      0: outputLandmarks.buffer,
      1: outputIdentity1.buffer,
      2: outputIdentity2.buffer,
      3: outputIdentity3.buffer,
      4: outputIdentity4.buffer,
    };

    interpreter!.runForMultipleInputs(inputs, outputs);

    if (outputIdentity1.getDoubleValue(0) < threshold) {
      return null;
    }

    // Data Shape Defined by: https://storage.googleapis.com/mediapipe-assets/Model%20Card%20BlazePose%20GHUM%203D.pdf
    // Further detail here: https://github.com/google/mediapipe/issues/4752
    final landmarkPoints = outputLandmarks
        .getDoubleList()
        .reshape<double>([39, 5]) as List<List<double>>;

    final width = (params?['width'] as double).toInt();
    final height = (params?['height'] as double).toInt();

    return PoseDetectionOutput(id, landmarkPoints, inputSize, width, height);
  }
}

PoseDetectionOutput? runPoseDetector(Map<String, dynamic> params) {
  final pose = PoseDetection(
      interpreter: Interpreter.fromAddress(params['detectorAddress']));

  final id = params['id'] as String;
  final input = params['input'] as TensorImage;

  final result = pose.predict(id, input, params['params']);

  return result;
}
