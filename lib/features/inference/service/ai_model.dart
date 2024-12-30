import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:visualpt/core/utils/image_utils.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';

// ignore: must_be_immutable
abstract class AiModel<I, O extends AiModelOutput> extends Equatable {
  AiModel({this.interpreter});

  final inputShapes = <List<int>>[];
  final inputTypes = <TfLiteType>[];
  final outputShapes = <List<int>>[];
  final outputTypes = <TfLiteType>[];

  Interpreter? interpreter;

  @override
  List<Object> get props => [];

  int get getAddress;

  Future<void> loadModel();
  O? predict(String id, I input, Map<String, dynamic>? params);

  void dispose() {
    interpreter?.close();
  }
}

abstract class AiModelOutput extends Identifiable {
  final dynamic output;

  const AiModelOutput(super.id, this.output);

  @override
  List<dynamic> get props => [id, output];
}

TensorImage toTensorImage(CameraImage input, {int size = 256}) {
  final image = ImageUtils.convertCameraImage(input);

  var tensorImage = TensorImage(TfLiteType.float32);
  tensorImage.loadImage(image);
  final imageProcessor = ImageProcessorBuilder()
      .add(ResizeOp(size, size, ResizeMethod.BILINEAR))
      .add(NormalizeOp(0, 255))
      .build();

  return imageProcessor.process(tensorImage);
}
