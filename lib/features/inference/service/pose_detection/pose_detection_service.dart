import 'dart:developer';

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';

import '../../constants/model_file.dart';
import '../ai_model.dart';

// ignore: must_be_immutable
class PoseDetection extends AiModel<TensorImage, PoseDetectionOutput> {
  PoseDetection() {
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

      final inputTensors = interpreter!.getInputTensors();
      print(inputTensors.toString());
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
  PoseDetectionOutput? predict(Map<String, dynamic> params) {
    if (interpreter == null) {
      log('Interpreter not initialized');
      return null;
    }

    String id = params['id'];
    TensorImage input = params['input'];

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
    // if (outputIdentity1.getDoubleValue(0) < threshold) {
    //   return null;
    // }

    // Data Shape Defined by: https://storage.googleapis.com/mediapipe-assets/Model%20Card%20BlazePose%20GHUM%203D.pdf
    // Further detail here: https://github.com/google/mediapipe/issues/4752
    final landmarkPoints = outputLandmarks
        .getDoubleList()
        .reshape<double>([39, 5]) as List<List<double>>;

    // Save the input TensorImage to a file with landmark points drawn
    // saveTensorImageWithLandmarks(
    //     input, landmarkPoints, 'input_image_with_landmarks.png');

    return PoseDetectionOutput(id, landmarkPoints);
  }

  // // Utility function to save TensorImage with landmarks drawn on it
  // void saveTensorImageWithLandmarks(
  //     TensorImage tensorImage, List<List<double>> landmarks, String filePath) {
  //   // Convert the TensorImage to a standard image (image_lib.Image)
  //   final image = tensorImage
  //       .image; // Assuming TensorImage can directly provide an image_lib.Image

  //   // Draw the landmark points on the image
  //   for (var landmark in landmarks) {
  //     final x = (landmark[0] * image.width).toInt(); // Scale X to image size
  //     final y = (landmark[1] * image.height).toInt(); // Scale Y to image size

  //     // Draw a small circle at each landmark point
  //     drawCircle(image,
  //         x: x,
  //         y: y,
  //         radius: 4,
  //         color: ColorUint8.rgb(255, 0, 0)); // Red circles
  //   }

  //   // Convert the image with landmarks to PNG bytes
  //   final pngBytes = encodePng(image);

  //   // Get the full path to the repository's testimage/ directory
  //   final fullPath = path.join(Directory.current.path, filePath);

  //   // Create the file and write the PNG bytes to it
  //   File(fullPath).createSync(recursive: true);
  //   File(fullPath).writeAsBytesSync(pngBytes);

  //   print('Input image with landmarks saved to: $fullPath');
  // }
}
