import 'package:equatable/equatable.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

// ignore: must_be_immutable
abstract class AiModel extends Equatable {
  AiModel({this.interpreter});

  final outputShapes = <List<int>>[];
  final outputTypes = <TfLiteType>[];

  Interpreter? interpreter;

  @override
  List<Object> get props => [];

  int get getAddress;

  Future<void> loadModel();
  TensorImage getProcessedImage(TensorImage inputImage);
  AiModelOutput? predict(image_lib.Image image);
}

abstract class AiModelOutput extends Equatable {
  final List<dynamic> output;

  const AiModelOutput(this.output);

  @override
  List<dynamic> get props => output;
}
