part of 'inference_bloc.dart';

abstract class Identifiable extends Equatable {
  final String id;
  const Identifiable(this.id);

  @override
  List<Object?> get props => throw UnimplementedError();
}

abstract class InferenceState<I, O> extends Equatable {
  final String id;
  final O? response;
  const InferenceState(this.response, this.id);

  @override
  List<Object> get props => [this.response ?? ""];
}

class InferenceLoading<I, O> extends InferenceState<I, O> {
  const InferenceLoading() : super(null, "Loading");

  @override
  List<Object> get props => [];
}

class InferenceRunning<I, O> extends InferenceState<I, O> {
  final Map<String, dynamic>? params;
  const InferenceRunning(super.response, super.id, this.params);

  @override
  List<Object> get props => [response ?? "", params ?? "", id];
}

class InferenceStandby<I, O> extends InferenceState<I, O> {
  const InferenceStandby() : super(null, "Standby");

  @override
  List<Object> get props => [];
}

class InferenceError<I, O> extends InferenceState<I, O> {
  final Exception error;
  const InferenceError({required this.error}) : super(null, "Error");

  @override
  List<Object> get props => [];
}
