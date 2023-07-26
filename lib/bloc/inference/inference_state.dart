part of 'inference_bloc.dart';

abstract class InferenceState extends Equatable {
  final AiModelOutput? response;
  const InferenceState(this.response);

  @override
  List<Object> get props => [];
}

class InferenceLoading extends InferenceState {
  const InferenceLoading(super.response);

  @override
  List<Object> get props => [];
}

class InferenceDone extends InferenceState {
  const InferenceDone(super.response);

  @override
  List<Object> get props => [];
}

class InferenceError extends InferenceState {
  const InferenceError(super.response);

  @override
  List<Object> get props => [];
}
