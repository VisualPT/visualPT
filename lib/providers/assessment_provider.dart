import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/app_nav.dart';

class AssessmentProvider extends StatefulWidget {
  final AssessmentType assessmentType;
  final void Function(BuildContext) getProviders;
  //final void Function() onComplete;
  final Widget Function(BuildContext context, AssessmentForm state) onForm;
  final Widget Function(BuildContext context, AssessmentIntro state) onIntro;
  final Widget Function(BuildContext context, AssessmentActive state) onActive;
  final Widget Function(BuildContext context, AssessmentSuccess state)
      onSuccess;
  final Widget Function(BuildContext context, AssessmentError state) onError;

  const AssessmentProvider({
    super.key,
    required this.assessmentType,
    required this.getProviders,
    //required this.onComplete,
    required this.onForm,
    required this.onIntro,
    required this.onActive,
    required this.onSuccess,
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
            create: (context) => AssessmentBloc(widget.assessmentType)),
        BlocProvider(create: (context) => PatientBloc()),
      ],
      child: BlocBuilder<AssessmentBloc, AssessmentState>(
        builder: (context, state) {
          widget.getProviders(context);
          try {
            if (state is AssessmentForm) {
              return widget.onForm(context, state);
            } else if (state is AssessmentIntro) {
              AppNav()
                  .back(context); //TODO solve for removing the loading screen
              return widget.onIntro(context, state);
            } else if (state is AssessmentActive) {
              return widget.onActive(context, state);
            } else if (state is AssessmentSuccess) {
              return widget.onSuccess(context, state);
            } else {
              throw Exception("Undefined State");
            }
          } catch (e) {
            return widget.onError(context, AssessmentError(Exception(e)));
          }
        },
      ),
    );
  }
}
