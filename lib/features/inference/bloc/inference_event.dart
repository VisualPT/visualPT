part of 'inference_bloc.dart';

abstract class InferenceEvent<I, O> extends Equatable {
  const InferenceEvent();

  @override
  List<Object?> get props => [];
}

class InferenceInit<I, O> extends InferenceEvent<I, O> {
  const InferenceInit();
}

class InferenceStart<I, O> extends InferenceEvent<I, O> {
  final double ratio;
  const InferenceStart(this.ratio);
}

class InferenceToggle<I, O> extends InferenceEvent<I, O> {
  final bool classification;
  const InferenceToggle(this.classification);
}

class InferenceInput<I, O> extends InferenceEvent<I, O> {
  final I input;
  final double ratio;
  const InferenceInput({required this.input, required this.ratio});

  @override
  List<Object> get props => [input.toString()];
}

class InferenceOutput<I, O> extends InferenceEvent<I, O> {
  final I input;
  final double ratio;
  final O? output;
  const InferenceOutput(
      {required this.input, required this.ratio, required this.output});

  @override
  List<Object?> get props => [output];
}

class InferenceEnd<I, O> extends InferenceEvent<I, O> {
  const InferenceEnd();
}
