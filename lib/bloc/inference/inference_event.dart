part of 'inference_bloc.dart';

abstract class InferenceEvent extends Equatable {
  const InferenceEvent();

  @override
  List<Object> get props => [];
}

class InferenceInit extends InferenceEvent {
  const InferenceInit();
}

class InferenceInput extends InferenceEvent {
  final CameraImage input;
  const InferenceInput({required this.input});

  @override
  List<Object> get props => [input];
}

class InferenceEnd extends InferenceEvent {
  const InferenceEnd();
}
