import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/components/_components.dart';

class AssessmentView extends StatelessWidget {
  final AssessmentType assessmentType;
  const AssessmentView({super.key, required this.assessmentType});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PatientBloc(),
        ),
        BlocProvider(
          create: (context) => AssessmentBloc(context, assessmentType),
        ),
        BlocProvider(
          create: (context) => CameraBloc(),
        )
      ],
      child: BlocBuilder<AssessmentBloc, AssessmentState>(
        builder: (context, assessmentState) {
          try {
            if (assessmentState is AssessmentForm) {
              return PatientForm(assessmentType: assessmentType);
              //return PatientForm(assessmentType: assessmentType,child: )
            } else if (assessmentState is AssessmentIntro) {
              WidgetsBinding.instance.addPostFrameCallback(
                  (_) => Navigator.pop(context)); //Clear the loading screen

              return BlocProvider.of<AssessmentBloc>(context).getIntroView(
                  context, assessmentType.name, assessmentState.index);
            } else if (assessmentState is AssessmentActive) {
              WidgetsBinding.instance.addPostFrameCallback(
                  (_) => Navigator.pop(context)); //Clear the loading screen
              return BlocProvider.of<AssessmentBloc>(context).getCaptureView(
                  context, assessmentType.name, assessmentState.index);
            } else if (assessmentState is AssessmentSuccess) {
              return BlocBuilder<PatientBloc, PatientState>(
                  builder: (context, patientState) {
                if (patientState is PatientActive) {
                  return BlocProvider.of<AssessmentBloc>(context)
                      .getAnalysisView(context, patientState.patient);
                } else {
                  ///PatientNull is the current state
                  ///Should never display this in an assessment
                  return const BaseView(
                      pageTitle: "No Patient Set",
                      child: Text("This should not be happening..."));
                }
              });

              //TODO Return loading Page
            } else {
              throw Exception("Undefined State");
            }
          } catch (e) {
            return BaseView(pageTitle: "Error", child: Text(e.toString()));
          }
        },
      ),
    );
  }
}
