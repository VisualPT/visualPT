import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../../constants/model_file.dart';
import '../../utils/image_utils.dart';
import '../ai_model.dart';

// ignore: must_be_immutable
class Pose extends AiModel {
  Pose({super.interpreter}) {
    loadModel();
  }
  final int inputSize = 256;
  final double threshold = 0.95;

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

      outputTensors.forEach((tensor) {
        outputShapes.add(tensor.shape);
        outputTypes.add(tensor.type);
      });
    } catch (e) {
      print('Error while creating interpreter: $e');
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
  PoseOutput? predict(image_lib.Image image) {
    if (interpreter == null) {
      print('Interpreter not initialized');
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

    if (landmarkPoints != null) {
      return PoseOutput(landmarkPoints, inputSize, image.width, image.height);
    }
  }
}

PoseOutput? runPoseEstimator(Map<String, dynamic> params) {
  final pose =
      Pose(interpreter: Interpreter.fromAddress(params['detectorAddress']));

  final image = ImageUtils.convertCameraImage(params['cameraImage']);
  final result = pose.predict(image!);

  return result;
}

class PoseOutput extends AiModelOutput {
  PoseOutput(super.output, int inputSize, int width, int height) {
    for (var point in output) {
      landmarks.add(Offset(
        point[0] / inputSize * width,
        point[1] / inputSize * height,
      ));
      depthPoints.add(point[2]);
      visibilityPoints.add(point[3]);
      presencePoints.add(point[4]);
    }
  }
  static const length = 33;
  final List<Offset> landmarks = [];
  final List<double> depthPoints = [];
  final List<double> visibilityPoints = [];
  final List<double> presencePoints = [];

  toMap() {
    return {
      'landmarkPoints': landmarks,
      'depthPoints': depthPoints,
      'visibilityPoints': visibilityPoints,
      'presencePoints': presencePoints
    };
  }

  toRaw() {
    return output;
  }
}
