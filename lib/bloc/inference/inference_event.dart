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
  final double ratio;
  const InferenceStart(this.ratio);
}

class InferenceToggle extends InferenceEvent {
  final bool classification;
  const InferenceToggle(this.classification);
}

class InferenceInput extends InferenceEvent {
  final CameraImage input;
  final double ratio;
  const InferenceInput({required this.input, required this.ratio});

  @override
  List<Object> get props => [input];
}

class InferenceOutput extends InferenceEvent {
  final CameraImage input;
  final double ratio;
  final AiModelOutput? output;
  const InferenceOutput(
      {required this.input, required this.ratio, required this.output});

  @override
  List<Object?> get props => [output];
}

class InferenceEnd extends InferenceEvent {
  const InferenceEnd();
}
