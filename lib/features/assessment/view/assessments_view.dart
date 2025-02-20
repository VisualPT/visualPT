import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/assessment/_assessment.dart';

class AssessmentsView extends StatelessWidget {
  const AssessmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: BaseView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Put a big piece of text here saying "Assessments", like iphone has "Messages"
            Flexible(
              flex: 2,
              fit: FlexFit.loose,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  padding: const EdgeInsets.all(8.0),
                  shrinkWrap: false,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text("Assessments",
                          style: Styles.title, textAlign: TextAlign.left),
                    ),
                    AssessmentCard(CTSIB()),
                    AssessmentCard(MCTSIB()),
                    AssessmentCard(BERG()),
                    kDebugMode ? AssessmentCard(DEV()) : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
