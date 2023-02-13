import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/assessments/_assessments.dart';
import 'package:visualpt/views/components/_components.dart';

import '../bloc/_bloc.dart';

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
            }
            if (state is AssessmentIntro) {
              return BaseView(
                  pageTitle: "Performing ${assessmentType.name}",
                  child: BlocProvider.of<AssessmentBloc>(context)
                      .getIntroView(context, state.index));
            }
            if (state is AssessmentActive) {
              return BlocProvider.of<AssessmentBloc>(context)
                  .getCaptureView(context, state.index);
            }
            if (state is AssessmentSuccess) {
              return BaseView(
                pageTitle: "Finished ${assessmentType.name}",
                child: Placeholder(),
              );
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
