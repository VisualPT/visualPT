import 'package:flutter/cupertino.dart';
import 'package:visualpt_collector/core/views/base_view.dart';
import 'package:visualpt_collector/features/assessment/bloc/assessment_bloc.dart';
import 'package:visualpt_collector/features/assessment/view/_assessments.dart';
import 'package:visualpt_collector/features/assessment/view/components/assessment_instructions.dart';
import 'package:visualpt_collector/features/video/view/capture_view.dart';

class AssessmentCapture<T extends BaseAssessment> extends StatelessWidget {
  final AssessmentActive<T> state;
  const AssessmentCapture(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
        pageTitle:
            "${state.assessment.type.name} - ${state.assessment.seqNames[state.index]}",
        instructions: AssessmentInstructions(state),
        child: CaptureView<T>(
          state.assessment.type,
          state.index,
          state.storeData,
        ));
  }
}
