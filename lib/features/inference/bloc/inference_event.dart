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
  final Map<String, dynamic> params;
  const InferenceStart(this.params);
}

class InferenceInput<I, O> extends InferenceEvent<I, O> {
  final I input;
  final Map<String, dynamic> params;
  const InferenceInput({required this.input, required this.params});

  @override
  List<Object> get props => [input.toString()];
}

class InferenceOutput<I, O> extends InferenceEvent<I, O> {
  final I input;
  final Map<String, dynamic> params;
  final O? output;
  const InferenceOutput(
      {required this.input, required this.params, required this.output});

  @override
  List<Object?> get props => [output];
}

class InferenceEnd<I, O> extends InferenceEvent<I, O> {
  const InferenceEnd();
}
