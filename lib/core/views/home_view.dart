import 'package:flutter/cupertino.dart';
import 'package:visualpt/features/assessment/config/_config.dart';
import 'package:visualpt/features/assessment/config/ctsib_collect/ctsib_collect.dart';
import 'package:visualpt/features/assessment/config/mctsib/mctsib.dart';
import 'package:visualpt/features/assessment/view/components/assessment_card.dart';
import 'package:visualpt/core/views/_views.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: BaseView(
        child: Column(
          children: [
            //TODO: Abstract the styling into a AssessmentCardList widget
            Flexible(
              flex: 2,
              fit: FlexFit.loose,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  prototypeItem: AssessmentCard(
                    CTSIB(),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  shrinkWrap: false,
                  children: [
                    AssessmentCard(CTSIB()),
                    AssessmentCard(MCTSIB()),
                    AssessmentCard(CTSIB_COLLECT()),
                    AssessmentCard(BERG()),
                    AssessmentCard(GAIT()),
                    AssessmentCard(REACH()),
                    AssessmentCard(FIST())
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
