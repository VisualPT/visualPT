import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/ai_model.dart';

class InferencePresenter<I, O extends AiModelOutput> extends StatelessWidget {
  const InferencePresenter({
    required this.onRunning,
    required this.onStopped,
    required this.onLoad,
    required this.onError,
    Key? key,
  }) : super(key: key);
  final Widget Function(BuildContext context, InferenceRunning<I, O> state)
      onRunning;
  final Widget Function(BuildContext context, InferenceStopped<I, O> state)
      onStopped;
  final Widget Function(BuildContext context, InferenceLoading<I, O> state)
      onLoad;
  final Widget Function(BuildContext context, InferenceError<I, O> state)
      onError;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InferenceBloc<I, O>, InferenceState<I, O>>(
      builder: (context, state) {
        try {
          return switch (state) {
            InferenceRunning<I, O>() => onRunning(context, state),
            InferenceStopped<I, O>() => onStopped(context, state),
            InferenceLoading<I, O>() => onLoad(context, state),
            InferenceError<I, O>() => onError(context, state),
            InferenceState<I, O>() =>
              throw Exception("Inference State: ${state.toString()}"),
          };
        } catch (e) {
          return onError(context, InferenceError(error: Exception(e)));
        }
      },
    );
  }
}
