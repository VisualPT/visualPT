part of 'inference_bloc.dart';

abstract class InferenceState<I, O> extends Equatable {
  final O? response;
  const InferenceState(this.response);

  @override
  List<Object> get props => [];
}

class InferenceLoading<I, O> extends InferenceState<I, O> {
  const InferenceLoading() : super(null);

  @override
  List<Object> get props => [];
}

class InferenceRunning<I, O> extends InferenceState<I, O> {
  final bool? isStoring;
  final Map<String, dynamic>? params;
  const InferenceRunning(super.response, this.isStoring, this.params);

  @override
  List<Object> get props => [response ?? "", params ?? ""];
}

class InferenceStandby<I, O> extends InferenceState<I, O> {
  const InferenceStandby() : super(null);

  @override
  List<Object> get props => [];
}

class InferenceError<I, O> extends InferenceState<I, O> {
  final Exception error;
  const InferenceError({required this.error}) : super(null);

  @override
  List<Object> get props => [];
}
