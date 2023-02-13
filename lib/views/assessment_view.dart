import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/components/_components.dart';

import '../bloc/_bloc.dart';

class AssessmentView extends StatelessWidget {
  final AssessmentType assessmentType;
  final List<Widget> assessmentViews;
  const AssessmentView(
      {super.key, required this.assessmentType, required this.assessmentViews});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AssessmentBloc(assessmentType, assessmentViews),
        ),
        BlocProvider(
          create: (context) => CameraBloc(),
        )
      ],
      child: BlocBuilder<AssessmentBloc, AssessmentState>(
        builder: (context, state) {
          try {
            if (state is AssessmentForm) {}
            if (state is AssessmentIntro) {
              return BaseView(
                  pageTitle: "Performing ${assessmentType.name}",
                  child: state.assessmentView);
            }
            if (state is AssessmentActive) {
              return VideoRecorder(onCaptureSaved: (File f) => {});
            }
            if (state is AssessmentSuccess) {
              return BaseView(
                  pageTitle: "Finished ${assessmentType.name}",
                  child: state.assessmentView);
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
