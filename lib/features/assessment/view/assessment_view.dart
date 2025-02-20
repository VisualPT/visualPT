import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/analysis/view/analysis_view.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/models/ModelProvider.dart';

class AssessmentView<T extends BaseAssessment> extends StatelessWidget {
  final T assessment;
  final Profile profile;

  const AssessmentView(
    this.assessment,
    this.profile, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AssessmentPresenter(
      assessment: assessment,
      profile: profile,
      onForm: (context, state) => AssessmentForm<T>(state),
      onActive: (context, state) => AssessmentCapture<T>(state),
      onAnalysis: (context, state) => AnalysisView(state),
      onError: (context, state) => BaseView(
        pageTitle: "Assessment Error",
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
