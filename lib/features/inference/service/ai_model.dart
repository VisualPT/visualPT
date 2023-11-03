import 'package:equatable/equatable.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

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
  O? predict(I input, Map<String, dynamic> params);
}

abstract class AiModelOutput extends Equatable {
  final dynamic output;

  const AiModelOutput(this.output);

  @override
  List<dynamic> get props => output;
}
