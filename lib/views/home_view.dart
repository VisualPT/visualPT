import 'package:flutter/cupertino.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/auth_service.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/app_nav.dart';
import 'components/_components.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: BaseView(
        pageTitle: "Select an assessment",
        child: Column(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: ListView(
                prototypeItem: const AssessmentCard(
                    imagePath: Styles.ctsibLogoPath,
                    assessmentType: AssessmentType.CTSIB,
                    subtitle: "Prototype Item"),
                shrinkWrap: false,
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
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoButton(
                  onPressed: () {
                    AuthService().signOut();
                    AppNav().setAuth(context);
                  },
                  child: const Text("SignOut"),
                )),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
