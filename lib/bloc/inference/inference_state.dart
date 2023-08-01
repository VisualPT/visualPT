part of 'inference_bloc.dart';

abstract class InferenceState extends Equatable {
  final bool ready;
  final AiModelOutput? response;
  const InferenceState(this.ready, this.response);

  @override
  List<Object> get props => [];
}

class InferenceLoading extends InferenceState {
  const InferenceLoading(super.ready, super.response);

  @override
  List<Object> get props => [];
}

class InferenceDone extends InferenceState {
  const InferenceDone(super.ready, super.response);

  @override
  List<Object> get props => [];
}

class InferenceError extends InferenceState {
  const InferenceError(super.ready, super.response);

  @override
  List<Object> get props => [];
}
