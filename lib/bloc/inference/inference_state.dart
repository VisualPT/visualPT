part of 'inference_bloc.dart';

abstract class InferenceState extends Equatable {
  const InferenceState();

  @override
  List<Object> get props => [];
}

class InferenceRunning extends InferenceState {
  final AiModelOutput? response;
  final double ratio;
  const InferenceRunning(this.response, this.ratio);

  @override
  List<Object> get props => [response ?? "", ratio];
}

class InferenceStopped extends InferenceState {
  const InferenceStopped();

  @override
  List<Object> get props => [];
}

class InferenceLoading extends InferenceState {
  const InferenceLoading();

  @override
  List<Object> get props => [];
}

class InferenceError extends InferenceState {
  final Exception error;
  const InferenceError({required this.error});

  @override
  List<Object> get props => [];
}
