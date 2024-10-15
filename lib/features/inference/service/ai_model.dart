import 'package:equatable/equatable.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';

// ignore: must_be_immutable
abstract class AiModel<I, O extends AiModelOutput> extends Equatable {
  AiModel();

  final inputShapes = <List<int>>[];
  final inputTypes = <TensorType>[];
  final outputShapes = <List<int>>[];
  final outputTypes = <TensorType>[];

  Interpreter? interpreter;

  @override
  List<Object> get props => [];

  int get getAddress;

  Future<void> loadModel();
  O? predict(Map<String, dynamic> params);
}

abstract class AiModelOutput extends Identifiable {
  final dynamic output;

  const AiModelOutput(super.id, this.output);

  @override
  List<dynamic> get props => [id, output];
}
