import 'dart:developer';

import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:visualpt/features/inference/service/pose_classification/pose_class_output.dart';

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
class PoseClassification extends AiModel {
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
    // final imageProcessor = ImageProcessorBuilder()
    //     .add(ResizeOp(inputSize, inputSize, ResizeMethod.BILINEAR))
    //     .add(NormalizeOp(0, 255))
    //     .build();

    // inputImage = imageProcessor.process(inputImage);
    return inputImage;
  }

  @override
  PoseClassificationOutput? predict(
      image_lib.Image image, Map<String, dynamic> params) {
    //   if (interpreter == null) {
    //     log('Interpreter not initialized');
    //     return null;
    //   }

    //   // if (Platform.isAndroid) {
    //   //   image = image_lib.copyRotate(image, -90);
    //   //   image = image_lib.flipHorizontal(image);
    //   // }
    //   final tensorImage = TensorImage(TfLiteType.float32);
    //   tensorImage.loadImage(image);
    //   final inputImage = getProcessedImage(tensorImage);

    //   TensorBuffer outputLandmarks = TensorBufferFloat(outputShapes[0]);
    //   TensorBuffer outputIdentity1 = TensorBufferFloat(outputShapes[1]);
    //   TensorBuffer outputIdentity2 = TensorBufferFloat(outputShapes[2]);
    //   TensorBuffer outputIdentity3 = TensorBufferFloat(outputShapes[3]);
    //   TensorBuffer outputIdentity4 = TensorBufferFloat(outputShapes[4]);

    //   final inputs = <Object>[inputImage.buffer];

    //   final outputs = <int, Object>{
    //     0: outputLandmarks.buffer,
    //     1: outputIdentity1.buffer,
    //     2: outputIdentity2.buffer,
    //     3: outputIdentity3.buffer,
    //     4: outputIdentity4.buffer,
    //   };

    //   interpreter!.runForMultipleInputs(inputs, outputs);

    //   if (outputIdentity1.getDoubleValue(0) < threshold) {
    //     return null;
    //   }

    //   //TODO: there are 33 landmarks, why is there 39 defined here?
    //   final landmarkPoints = outputLandmarks
    //       .getDoubleList()
    //       .reshape<double>([39, 5]) as List<List<double>>;

    //   final ratio = params['ratio'] as double;

    //   return PoseClassificationOutput(
    //       landmarkPoints, inputSize, image.width, image.height, ratio);
  }
}

PoseClassificationOutput? runPoseClassifier(Map<String, dynamic> params) {
  final pose = PoseClassification(
      interpreter: Interpreter.fromAddress(params['detectorAddress']));

  // final image = ImageUtils.convertCameraImage(params['input']);
  // final result = pose.predict(image, params['params']);

  // return result;
}
