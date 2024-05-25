import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../../constants/model_file.dart';
import '../../../../core/utils/image_utils.dart';
import '../ai_model.dart';
import 'anchors.dart';
import 'generate_anchors.dart';
import 'non_maximum_suppression.dart';
import 'options.dart';
import 'process.dart';

// ignore: must_be_immutable
class FaceDetection extends AiModel<image_lib.Image, FaceBboxOutput> {
  FaceDetection({this.interpreter}) {
    loadModel();
  }

  final int inputSize = 128;
  final double threshold = 0.7;

  @override
  Interpreter? interpreter;

  @override
  List<Object> get props => [];

  @override
  int get getAddress => interpreter!.address;

  late ImageProcessor _imageProcessor;
  late List<Anchor> _anchors;

  @override
  Future<void> loadModel() async {
    final anchorOption = AnchorOption(
        inputSizeHeight: 128,
        inputSizeWidth: 128,
        minScale: 0.1484375,
        maxScale: 0.75,
        anchorOffsetX: 0.5,
        anchorOffsetY: 0.5,
        numLayers: 4,
        featureMapHeight: [],
        featureMapWidth: [],
        strides: [8, 16, 16, 16],
        aspectRatios: [1.0],
        reduceBoxesInLowestLayer: false,
        interpolatedScaleAspectRatio: 1.0,
        fixedAnchorSize: true);
    try {
      final interpreterOptions = InterpreterOptions();

      _anchors = generateAnchors(anchorOption);
      interpreter = interpreter ??
          await Interpreter.fromAsset(
            ModelFile.faceDetection,
            options: interpreterOptions,
          );

      final outputTensors = interpreter!.getOutputTensors();

      outputTensors.forEach((tensor) {
        outputShapes.add(tensor.shape);
        outputTypes.add(tensor.type);
      });
    } catch (e) {
      log('Error while creating interpreter: $e');
    }
  }

  TensorImage getProcessedImage(TensorImage inputImage) {
    _imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(inputSize, inputSize, ResizeMethod.BILINEAR))
        .add(NormalizeOp(127.5, 127.5))
        .build();

    inputImage = _imageProcessor.process(inputImage);
    return inputImage;
  }

  @override
  FaceBboxOutput? predict(
      String id, image_lib.Image input, Map<String, dynamic>? params) {
    if (interpreter == null) {
      log('Interpreter not initialized');
      return null;
    }

    final options = OptionsFace(
        numClasses: 1,
        numBoxes: 896,
        numCoords: 16,
        keypointCoordOffset: 4,
        ignoreClasses: [],
        scoreClippingThresh: 100.0,
        minScoreThresh: 0.75,
        numKeypoints: 6,
        numValuesPerKeypoint: 2,
        reverseOutputOrder: true,
        boxCoordOffset: 0,
        xScale: 128,
        yScale: 128,
        hScale: 128,
        wScale: 128);

    if (Platform.isAndroid) {
      input = image_lib.copyRotate(input, angle: -90);
      input = image_lib.flipHorizontal(input);
    }
    final tensorImage = TensorImage(TfLiteType.float32);
    tensorImage.loadImage(input);
    final inputImage = getProcessedImage(tensorImage);

    TensorBuffer outputFaces = TensorBufferFloat(outputShapes[0]);
    TensorBuffer outputScores = TensorBufferFloat(outputShapes[1]);

    final inputs = <Object>[inputImage.buffer];

    final outputs = <int, Object>{
      0: outputFaces.buffer,
      1: outputScores.buffer,
    };

    interpreter!.runForMultipleInputs(inputs, outputs);

    final rawBoxes = outputFaces.getDoubleList();
    final rawScores = outputScores.getDoubleList();
    var detections = process(
        options: options,
        rawScores: rawScores,
        rawBoxes: rawBoxes,
        anchors: _anchors);

    detections = nonMaximumSuppression(detections, threshold);
    if (detections.isEmpty) {
      return null;
    }

    final rectFaces = <Map<String, dynamic>>[];

    for (var detection in detections) {
      Rect? bbox;
      final score = detection.score;
      if (score > threshold) {
        bbox = Rect.fromLTRB(
          inputImage.width * detection.xMin,
          inputImage.height * detection.yMin,
          inputImage.width * detection.width,
          inputImage.height * detection.height,
        );

        bbox = _imageProcessor.inverseTransformRect(
            bbox, input.height, input.width);
      }
      rectFaces.add({'bbox': bbox, 'score': score});
    }
    rectFaces.sort((a, b) => b['score'].compareTo(a['score']));

    //return rectFaces[0]
    return FaceBboxOutput(id, rectFaces);
  }
}

FaceBboxOutput? runFaceDetector(Map<String, dynamic> params) {
  final faceDetection = FaceDetection(
      interpreter: Interpreter.fromAddress(params['detectorAddress']));
  final id = params['id'] as String;
  final input = ImageUtils.convertCameraImage(params['input']);
  final result = faceDetection.predict(id, input, {});

  return result;
}

class FaceBboxOutput extends AiModelOutput {
  const FaceBboxOutput(super.id, super.output);

  @override
  List<dynamic> get props => output;
}
