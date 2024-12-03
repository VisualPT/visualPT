import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/views/base_view.dart';
import 'package:visualpt/features/assessment/bloc/assessment_bloc.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/assessment/view/components/assessment_instructions.dart';
import 'package:visualpt/features/video/view/capture_view.dart';

class AssessmentCapture<T extends BaseAssessment> extends StatelessWidget {
  final AssessmentActive<T> state;
  const AssessmentCapture(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
        pageTitle:
            "${state.meta.type.name} Condition ${state.trialMeta.condition + 1} Trial ${state.trialMeta.trial + 1} \n ${state.meta.conditionNames[state.trialMeta.condition]}",
        instructions: AssessmentInstructions(state),
        poppable: false,
        child: CaptureView<T>(
          state,
        ));
  }
}
