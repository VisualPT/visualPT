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
  final bool store;
  final Map<String, dynamic>? params;
  const InferenceStart({required this.store, this.params});
}

// class InferenceAdd<I, O> extends InferenceEvent<I, O> {
//   final I input;
//   const InferenceAdd({required this.input});
// }

class InferenceInput<I, O> extends InferenceEvent<I, O> {
  final I input;
  final bool store;
  final Map<String, dynamic>? params;
  const InferenceInput(
      {required this.input, required this.store, required this.params});

  @override
  List<Object> get props => [input.toString()];
}

class InferenceOutput<I, O> extends InferenceEvent<I, O> {
  final I input;
  final bool store;
  final Map<String, dynamic>? params;
  final O? output;
  const InferenceOutput(
      {required this.input, required this.store, this.params, this.output});

  @override
  List<Object?> get props => [output];
}

class InferenceEnd<I, O> extends InferenceEvent<I, O> {
  const InferenceEnd();
}
