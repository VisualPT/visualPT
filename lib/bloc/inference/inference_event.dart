part of 'inference_bloc.dart';

abstract class InferenceEvent extends Equatable {
  const InferenceEvent();

  @override
  List<Object?> get props => [];
}

class InferenceInit extends InferenceEvent {
  const InferenceInit();
}

class InferenceStart extends InferenceEvent {
  const InferenceStart();
}

class InferenceInput extends InferenceEvent {
  final CameraImage input;
  final bool classification;
  const InferenceInput({required this.input, required this.classification});

  @override
  List<Object> get props => [input];
}

class InferenceOutput extends InferenceEvent {
  final CameraImage? image;
  final AiModelOutput? output;
  const InferenceOutput({required this.image, required this.output});

  @override
  List<Object?> get props => [output];
}

class InferenceEnd extends InferenceEvent {
  const InferenceEnd();
}
