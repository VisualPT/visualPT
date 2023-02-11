import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/views/components/_components.dart';
import 'package:visualpt/views/_views.dart';

import '../bloc/_bloc.dart';

class AssessmentView extends StatelessWidget {
  const AssessmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      pageTitle: "Performing <Assessment>",
      child: BlocProvider(
        create: (context) => AssessmentBloc(),
        child: BlocBuilder<AssessmentBloc, AssessmentState>(
          builder: (context, state) {
            return Text("ToDo");
            if (state is AssessmentTutorial) {
            } else if (state is AssessmentActive) {
              return VideoRecorder();
            } else if (state is AssessmentAborted) {
              //Reset the video recorder /
            } else if (state is AssessmentPaused) {
              //Pause the video recorder and timer / show a modal over the recorder
            } else if (state is AssessmentSuccess) {
              //Go to PDF
            } else {
              assert(state is AssessmentError);
            }
          },
        ),
      ),
    );
  }
}
