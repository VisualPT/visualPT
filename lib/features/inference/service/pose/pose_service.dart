import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../../constants/model_file.dart';
import '../../../../core/utils/image_utils.dart';
import '../ai_model.dart';

// ignore: must_be_immutable
class Pose extends AiModel {
  Pose({super.interpreter}) {
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

      interpreter ??= await Interpreter.fromAsset(ModelFile.pose,
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
  TensorImage getProcessedImage(TensorImage inputImage) {
    final imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(inputSize, inputSize, ResizeMethod.BILINEAR))
        .add(NormalizeOp(0, 255))
        .build();

    inputImage = imageProcessor.process(inputImage);
    return inputImage;
  }

  @override
  PoseOutput? predict(image_lib.Image image, Map<String, dynamic> params) {
    if (interpreter == null) {
      log('Interpreter not initialized');
      return null;
    }

    // if (Platform.isAndroid) {
    //   image = image_lib.copyRotate(image, -90);
    //   image = image_lib.flipHorizontal(image);
    // }
    final tensorImage = TensorImage(TfLiteType.float32);
    tensorImage.loadImage(image);
    final inputImage = getProcessedImage(tensorImage);

    TensorBuffer outputLandmarks = TensorBufferFloat(outputShapes[0]);
    TensorBuffer outputIdentity1 = TensorBufferFloat(outputShapes[1]);
    TensorBuffer outputIdentity2 = TensorBufferFloat(outputShapes[2]);
    TensorBuffer outputIdentity3 = TensorBufferFloat(outputShapes[3]);
    TensorBuffer outputIdentity4 = TensorBufferFloat(outputShapes[4]);

    final inputs = <Object>[inputImage.buffer];

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

    //TODO: there are 33 landmarks, why is there 39 defined here?
    final landmarkPoints = outputLandmarks
        .getDoubleList()
        .reshape<double>([39, 5]) as List<List<double>>;

    final ratio = params['ratio'] as double;

    return PoseOutput(
        landmarkPoints, inputSize, image.width, image.height, ratio);
  }
}

PoseOutput? runPoseEstimator(Map<String, dynamic> params) {
  final pose =
      Pose(interpreter: Interpreter.fromAddress(params['detectorAddress']));

  final image = ImageUtils.convertCameraImage(params['cameraImage']);
  final result = pose.predict(image!, params['params']);

  return result;
}

class PoseOutput extends AiModelOutput {
  PoseOutput(super.output, int inputSize, int width, int height, double ratio) {
    const double percentOfImageHeightThreshold = 0.5;

    double min = height.roundToDouble(), max = 0;

    for (var point in output) {
      final double dx =
          point[0] / inputSize.toDouble() * width.toDouble() * ratio;
      final double dy =
          point[1] / inputSize.toDouble() * height.toDouble() * ratio;
      if (dy < min) {
        min = dy;
      }
      if (dy > max) {
        max = dy;
      }
      landmarks.add(Offset(dx, dy));
      depthPoints.add(point[2]);
      visibilityPoints.add(point[3]);
      presencePoints.add(point[4]);
    }
    heightThreshold =
        max - min > (height * ratio * percentOfImageHeightThreshold);
  }

  static const length = 33;
  final List<Offset> landmarks = [];
  final List<double> depthPoints = [];
  final List<double> visibilityPoints = [];
  final List<double> presencePoints = [];
  bool heightThreshold = false;

  toMap() {
    return {
      'landmarkPoints': landmarks,
      'depthPoints': depthPoints,
      'visibilityPoints': visibilityPoints,
      'presencePoints': presencePoints,
      'heightThreshold': heightThreshold,
    };
  }

  toRaw() {
    return output;
  }

  @override
  List<Object> get props => [landmarks, depthPoints, visibilityPoints];
}
