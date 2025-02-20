import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/assessment/_assessment.dart';

class AssessmentInstructions<T extends BaseAssessment> extends StatelessWidget {
  final AssessmentActive<T> state;
  const AssessmentInstructions(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    var formattedInstructionList = state
        .meta.conditionInstructions[state.trialMeta.stage]
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
              "Stage ${(state.trialMeta.stage + 1).toString()} of ${state.meta.stages.toString()}",
              style: Styles.heading1),
          Text(
            state.meta.conditionNames[state.trialMeta.stage],
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
