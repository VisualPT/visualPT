import 'package:flutter/cupertino.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/_views.dart';
import 'components/_components.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: BaseView(
        pageTitle: "Select an assessment",
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: const [
            AssessmentCard(
                imagePath: Styles.ctsibLogoPath,
                assessmentType: AssessmentType.CTSIB,
                subtitle: "3 minutes"),
            AssessmentCard(
              imagePath: Styles.gvLogoPath,
              assessmentType: AssessmentType.GAIT,
              subtitle: "5 minutes",
              available: false,
            ),
          ],
        ),
      ),
    );
  }
}
