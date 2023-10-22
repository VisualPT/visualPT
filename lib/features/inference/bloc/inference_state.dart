part of 'inference_bloc.dart';

abstract class InferenceState extends Equatable {
  final AiModelOutput? response;
  const InferenceState(this.response);

  @override
  List<Object> get props => [];
}

class InferenceRunning extends InferenceState {
  final double ratio;
  const InferenceRunning(super.response, this.ratio);

  @override
  List<Object> get props => [response ?? "", ratio];
}

class InferenceStopped extends InferenceState {
  const InferenceStopped() : super(null);

  @override
  List<Object> get props => [];
}

class InferenceLoading extends InferenceState {
  const InferenceLoading() : super(null);

  @override
  List<Object> get props => [];
}

class InferenceError extends InferenceState {
  final Exception error;
  const InferenceError({required this.error}) : super(null);

  @override
  List<Object> get props => [];
}
