import 'package:flutter/cupertino.dart';
import 'package:visualpt_collector/features/assessment/view/components/assessment_card.dart';
import 'package:visualpt_collector/models/ModelProvider.dart';
import 'package:visualpt_collector/core/views/_views.dart';

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
                  prototypeItem: const AssessmentCard(
                      imagePath: Styles.ctsibLogoPath,
                      assessmentType: AssessmentType.CTSIB,
                      subtitle: "Prototype"),
                  padding: const EdgeInsets.all(8.0),
                  shrinkWrap: false,
                  scrollDirection: Axis.horizontal,
                  children: const [
                    AssessmentCard(
                        imagePath: Styles.ctsibLogoPath,
                        assessmentType: AssessmentType.CTSIB,
                        subtitle: "5 minutes"),
                    AssessmentCard(
                      imagePath: Styles.bergLogoPath,
                      assessmentType: AssessmentType.BERG,
                      subtitle: "10 minutes",
                    ),
                    AssessmentCard(
                      imagePath: Styles.gvLogoPath,
                      assessmentType: AssessmentType.GAIT,
                      subtitle: "5 minutes",
                      available: false,
                    ),
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
