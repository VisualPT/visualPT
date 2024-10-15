import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../../constants/model_file.dart';
import '../ai_model.dart';

// ignore: must_be_immutable
class FaceMesh extends AiModel<image_lib.Image, FaceOutput> {
  FaceMesh({this.interpreter}) {
    loadModel();
  }

  final int inputSize = 192;

  @override
  Interpreter? interpreter;

  @override
  List<Object> get props => [];

  @override
  int get getAddress => interpreter!.address;

  @override
  Future<void> loadModel() async {
    try {
      final interpreterOptions = InterpreterOptions();

      interpreter ??= await Interpreter.fromAsset(ModelFile.faceMesh,
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

  TensorImage getProcessedImage(TensorImage inputImage) {
    final imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(inputSize, inputSize, ResizeMethod.BILINEAR))
        .add(NormalizeOp(0, 255))
        .build();

    inputImage = imageProcessor.process(inputImage);
    return inputImage;
  }

  @override
  FaceOutput? predict(Map<String, dynamic> params) {
    if (interpreter == null) {
      log('Interpreter not initialized');
      return null;
    }
    final String id = params['id'];
    image_lib.Image input = params['input'];

    if (Platform.isAndroid) {
      input = image_lib.copyRotate(input, angle: -90);
      input = image_lib.flipHorizontal(input);
    }
    final tensorImage = TensorImage(TensorType.float32);
    tensorImage.loadImage(input);
    final inputImage = getProcessedImage(tensorImage);

    TensorBuffer outputLandmarks = TensorBufferFloat(outputShapes[0]);
    TensorBuffer outputScores = TensorBufferFloat(outputShapes[1]);

    final inputs = <Object>[inputImage.buffer];

    final outputs = <int, Object>{
      0: outputLandmarks.buffer,
      1: outputScores.buffer,
    };

    interpreter!.runForMultipleInputs(inputs, outputs);

    if (outputScores.getDoubleValue(0) < 0) {
      return null;
    }

    final landmarkPoints = outputLandmarks.getDoubleList().reshape([468, 3]);
    final landmarkResults = <Offset>[];
    for (var point in landmarkPoints) {
      landmarkResults.add(Offset(
        point[0] / inputSize * input.width,
        point[1] / inputSize * input.height,
      ));
    }
    return FaceOutput(id, landmarkResults);
  }
}

class FaceOutput extends AiModelOutput {
  const FaceOutput(super.id, super.output);

  @override
  List<dynamic> get props => output;
}
