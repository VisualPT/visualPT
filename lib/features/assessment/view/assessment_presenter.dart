import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/core/views/components/_components.dart';
import 'package:visualpt/features/assessment/bloc/assessment_bloc.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';

///Provided PatientBloc & AssessmentBloc
class AssessmentPresenter<T extends BaseAssessment> extends StatelessWidget {
  final T assessment;
  final Widget Function(BuildContext context, AssessmentForm<T> state) onForm;
  final Widget Function(BuildContext context, AssessmentActive<T> state)
      onActive;
  final Widget Function(BuildContext context, AssessmentAnalysis<T> state)
      onAnalysis;
  final Widget Function(BuildContext context, AssessmentError<T> state) onError;

  const AssessmentPresenter({
    super.key,
    required this.assessment,
    required this.onForm,
    required this.onActive,
    required this.onAnalysis,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AssessmentBloc<T>(assessment)),
      ],
      child: BlocBuilder<AssessmentBloc<T>, AssessmentState<T>>(
        builder: (context, state) {
          try {
            if (state is AssessmentForm<T>) {
              return onForm(context, state);
            } else if (state is AssessmentLoading) {
              return const AppLoading(
                  message: "Loading the next part of your assessment");
            } else if (state is AssessmentActive<T>) {
              return onActive(context, state);
            } else if (state is AssessmentAnalysis<T>) {
              return onAnalysis(context, state);
            } else {
              throw Exception("Undefined State $state");
            }
          } catch (e) {
            return onError(context, AssessmentError(Exception(e), assessment));
          }
        },
      ),
    );
  }
}
