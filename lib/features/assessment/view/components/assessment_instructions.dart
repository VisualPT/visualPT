import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/views/_views.dart';
import 'package:visualpt/features/assessment/bloc/assessment_bloc.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';

class AssessmentInstructions<T extends BaseAssessment> extends StatelessWidget {
  final AssessmentActive<T> state;
  const AssessmentInstructions(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    var formattedInstructionList =
        state.assessment.seqInstructions[state.index].map((instruction) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(instruction, textAlign: TextAlign.center),
      );
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Spacer(),
        Text(
            "Criteria ${(state.index + 1).toString()} of ${state.assessment.sequences.toString()}",
            style: Styles.subactionText),
        const Spacer(),
        Container(
          height: 2,
          width: MediaQuery.of(context).size.width * 0.8,
          color: Styles.black,
        ),
        Text(
          state.assessment.seqNames[state.index],
          style: Styles.title,
          textAlign: TextAlign.center,
        ),
        Container(
          height: 2,
          width: MediaQuery.of(context).size.width * 0.8,
          color: Styles.black,
        ),
        const Spacer(),
        const Text("Before getting started: ",
            style: Styles.heading3, textAlign: TextAlign.center),
        const Spacer(),
        ...formattedInstructionList,
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
                color: Styles.actionPrimary,
                borderRadius: Styles.borderRadiusM),
            child: const Text("Ok, I'm ready!",
                style: Styles.actionText, textAlign: TextAlign.center),
          ),
        ),
        const Spacer()
      ],
    );
  }
}
