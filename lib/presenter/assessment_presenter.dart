import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';

///Provided PatientBloc & AssessmentBloc
class AssessmentPresenter extends StatelessWidget {
  final AssessmentType assessmentType;
  final Patient patient;
  final Widget Function(BuildContext context, AssessmentIntro state) onIntro;
  final Widget Function(BuildContext context, AssessmentActive state) onActive;
  final Widget Function(BuildContext context, AssessmentAnalysis state)
      onAnalysis;
  final Widget Function(BuildContext context, AssessmentError state) onError;

  const AssessmentPresenter({
    super.key,
    required this.assessmentType,
    required this.patient,
    required this.onIntro,
    required this.onActive,
    required this.onAnalysis,
    required this.onError,
  });

  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AssessmentBloc(assessmentType)
              ..add(AssessmentInitial(
                context: context,
                patient: patient,
              ))),
        BlocProvider(create: (context) => PatientBloc()),
      ],
      child: BlocBuilder<AssessmentBloc, AssessmentState>(
        builder: (context, state) {
          try {
            if (state is AssessmentIntro) {
              return onIntro(context, state);
            } else if (state is AssessmentActive) {
              return onActive(context, state);
            } else if (state is AssessmentAnalysis) {
              return onAnalysis(context, state);
            } else {
              throw Exception("Undefined State");
            }
          } catch (e) {
            return onError(context, AssessmentError(message: Exception(e)));
          }
        },
      ),
    );
  }
}
