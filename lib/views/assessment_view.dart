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
          create: (context) => AssessmentBloc(context, assessmentType),
        ),
        BlocProvider(
          create: (context) => CameraBloc(),
        )
      ],
      child: BlocBuilder<AssessmentBloc, AssessmentState>(
        builder: (context, state) {
          try {
            if (state is AssessmentForm) {
              return PatientForm(assessmentType: assessmentType);
              //return PatientForm(assessmentType: assessmentType,child: )
            } else if (state is AssessmentIntro) {
              WidgetsBinding.instance.addPostFrameCallback(
                  (_) => Navigator.pop(context)); //Clear the loading screen

              return BlocProvider.of<AssessmentBloc>(context)
                  .getIntroView(context, assessmentType.name, state.index);
            } else if (state is AssessmentActive) {
              WidgetsBinding.instance.addPostFrameCallback(
                  (_) => Navigator.pop(context)); //Clear the loading screen
              return BlocProvider.of<AssessmentBloc>(context)
                  .getCaptureView(context, assessmentType.name, state.index);
            } else if (state is AssessmentSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) =>
                  Navigator.pushReplacementNamed(context, "/analysis",
                      arguments: [
                        assessmentType.name,
                        state.assessmentAssets
                      ]));

              //TODO Return loading Page
              return const CupertinoActivityIndicator();
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
