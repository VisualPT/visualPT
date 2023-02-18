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
              return BaseView(
                  pageTitle: "Performing ${assessmentType.name}",
                  child: BlocProvider.of<AssessmentBloc>(context)
                      .getIntroView(context, state.index));
            } else if (state is AssessmentActive) {
              return BlocProvider.of<AssessmentBloc>(context)
                  .getCaptureView(context, state.index);
            } else if (state is AssessmentSuccess) {
              Navigator.pushReplacementNamed(context, "analysis",
                  arguments: [assessmentType.name, state.assessmentAssets]);
              //TODO Return loading Page
              return const CupertinoActivityIndicator();
            } else {
              throw Exception("Undefined State");
            }
          } on Exception catch (e) {
            return BaseView(pageTitle: "Error", child: Text(e.toString()));
          }
        },
      ),
    );
  }
}
