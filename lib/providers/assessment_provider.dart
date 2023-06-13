import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';

class AssessmentProvider extends StatefulWidget {
  final AssessmentType assessmentType;
  final Patient patient;
  final void Function(BuildContext) getProviders;
  //final Widget Function(BuildContext context, AssessmentForm state) onForm;
  final Widget Function(BuildContext context, AssessmentIntro state) onIntro;
  final Widget Function(BuildContext context, AssessmentActive state) onActive;
  final Widget Function(BuildContext context, AssessmentAnalysis state)
      onAnalysis;
  final Widget Function(BuildContext context, AssessmentError state) onError;

  const AssessmentProvider({
    super.key,
    required this.assessmentType,
    required this.patient,
    required this.getProviders,
    //required this.onForm,
    required this.onIntro,
    required this.onActive,
    required this.onAnalysis,
    required this.onError,
  });

  @override
  State<AssessmentProvider> createState() => AssessmentProviderState();
}

class AssessmentProviderState extends State<AssessmentProvider> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AssessmentBloc(widget.assessmentType)
              ..add(AssessmentInitial(
                context: context,
                patient: widget.patient,
              ))),
        BlocProvider(create: (context) => PatientBloc()),
      ],
      child: BlocBuilder<AssessmentBloc, AssessmentState>(
        builder: (context, state) {
          widget.getProviders(context);
          try {
            if (state is AssessmentIntro) {
              return widget.onIntro(context, state);
            } else if (state is AssessmentActive) {
              return widget.onActive(context, state);
            } else if (state is AssessmentAnalysis) {
              return widget.onAnalysis(context, state);
            } else {
              throw Exception("Undefined State");
            }
          } catch (e) {
            return widget.onError(
                context, AssessmentError(message: Exception(e)));
          }
        },
      ),
    );
  }
}
