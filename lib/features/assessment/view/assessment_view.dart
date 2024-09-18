import 'package:flutter/cupertino.dart';
import 'package:visualpt/features/analysis/view/analysis_view.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/assessment/view/assessment_form.dart';
import 'package:visualpt/features/assessment/view/components/assessment_capture.dart';
import 'package:visualpt/features/assessment/view/assessment_presenter.dart';
import 'package:visualpt/core/views/_views.dart';

class AssessmentView<T extends BaseAssessment> extends StatelessWidget {
  final T assessment;

  const AssessmentView(
    this.assessment, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AssessmentPresenter(
      assessment: assessment,
      onForm: (context, state) => AssessmentForm<T>(assessment: assessment),
      onActive: (context, state) => AssessmentCapture<T>(state),
      onAnalysis: (context, state) => AnalysisView(state, assessment),
      onError: (context, state) => BaseView(
        pageTitle: "Assessment State Error",
        //Create a child view that has the error message and a button to go back
        child: Column(
          children: [
            Text(state.message.toString()),
            CupertinoButton(
                onPressed: () => AppNav(context).back(),
                child: const Text("Restart Assessment"))
          ],
        ),
      ),
    );
  }
}
