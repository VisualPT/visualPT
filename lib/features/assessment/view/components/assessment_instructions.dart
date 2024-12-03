import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/views/_views.dart';
import 'package:visualpt/features/assessment/bloc/assessment_bloc.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';

class AssessmentInstructions<T extends BaseAssessment> extends StatelessWidget {
  final AssessmentActive<T> state;
  const AssessmentInstructions(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    var formattedInstructionList = state
        .meta.conditionInstructions[state.trialMeta.condition]
        .map((instruction) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(instruction, textAlign: TextAlign.center),
      );
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          Text(state.trialMeta.assessment.name, style: Styles.title),
          Text(
              "Condition ${(state.trialMeta.condition + 1).toString()} of ${state.meta.conditions.toString()}",
              style: Styles.heading1),
          Text(
            state.meta.conditionNames[state.trialMeta.condition],
            style: Styles.heading1,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Container(
            height: 2,
            width: MediaQuery.of(context).size.width * 0.8,
            color: Styles.black,
          ),
          const Spacer(),
          const Text("Patient Instructions: ",
              style: Styles.heading2, textAlign: TextAlign.center),
          const Spacer(),
          Text("TODO: Add patient instructions"),
          const Spacer(),
          Container(
            height: 300,
            width: MediaQuery.of(context).size.width * 0.3,
            color: Styles.gray.withOpacity(0.4), // Placeholder color
            child: const Center(
              child: Text(
                'Patient Image Placeholder',
              ),
            ),
          ),
          const Spacer(),
          Container(
            height: 2,
            width: MediaQuery.of(context).size.width * 0.8,
            color: Styles.black,
          ),
          const Spacer(),
          const Text("Therapist Instructions: ",
              style: Styles.heading2, textAlign: TextAlign.center),
          const Spacer(),
          ...formattedInstructionList,
          const Spacer(),
          Row(children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    color: Styles.errorRed, borderRadius: Styles.borderRadiusM),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Abort",
                      style: Styles.actionText, textAlign: TextAlign.center),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    color: Styles.actionSecondary,
                    borderRadius: Styles.borderRadiusM),
                child: const Text("Start",
                    style: Styles.actionText, textAlign: TextAlign.center),
              ),
            ),
            const Spacer(),
          ])
        ],
      ),
    );
  }
}
