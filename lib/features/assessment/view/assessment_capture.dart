import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/assessment/bloc/assessment_bloc.dart';
import 'package:visualpt/features/assessment/config/base.dart';
import 'package:visualpt/features/assessment/view/components/assessment_instructions.dart';
import 'package:visualpt/features/capture/view/capture_view.dart';

class AssessmentCapture<T extends BaseAssessment> extends StatelessWidget {
  final AssessmentActive<T> state;
  const AssessmentCapture(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
        pageTitle:
            "${state.config.type.name} Stage ${state.meta.stage + 1} Trial ${state.meta.trial + 1} \n ${state.config.stageNames[state.meta.stage]}",
        instructions: AssessmentInstructions(state),
        poppable: false,
        backgroundColor: Styles.white,
        child: CaptureView<T>(state));
  }
}
