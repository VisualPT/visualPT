import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/assessment/bloc/assessment_bloc.dart';
import 'package:visualpt/features/assessment/config/base.dart';
import 'package:visualpt/models/ModelProvider.dart';

class AssessmentPresenter<T extends BaseAssessment> extends StatelessWidget {
  final T assessment;
  final Profile profile;
  final Widget Function(BuildContext context, AssessmentInputs<T> state) onForm;
  final Widget Function(BuildContext context, AssessmentActive<T> state)
      onActive;
  final Widget Function(BuildContext context, AssessmentAnalysis<T> state)
      onAnalysis;
  final Widget Function(BuildContext context, AssessmentError<T> state) onError;

  const AssessmentPresenter({
    super.key,
    required this.assessment,
    required this.profile,
    required this.onForm,
    required this.onActive,
    required this.onAnalysis,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AssessmentBloc<T>(assessment, profile),
      child: BlocBuilder<AssessmentBloc<T>, AssessmentState<T>>(
        builder: (context, state) {
          try {
            return switch (state) {
              AssessmentLoading() => const AppLoading(
                  message: "Loading the next part of your assessment"),
              AssessmentInputs<T>() => onForm(context, state),
              AssessmentActive<T>() => onActive(context, state),
              AssessmentAnalysis<T>() => onAnalysis(context, state),
              AssessmentError<T>() => onError(context, state),
              _ => throw Exception("Undefined State $state"),
            };
          } catch (e) {
            return onError(
                context,
                AssessmentError(
                    Exception(e), assessment, assessment.formFields));
          }
        },
      ),
    );
  }
}
