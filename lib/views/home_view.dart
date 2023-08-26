import 'package:flutter/cupertino.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/app_nav.dart';
import 'components/_components.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = AppNav(context);

    return CupertinoPageScaffold(
      child: BaseView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                      imagePath: Styles.gvLogoPath,
                      assessmentType: AssessmentType.GAIT,
                      subtitle: "5 minutes",
                      available: false,
                    ),
                  ],
                ),
              ),
            ),
            CupertinoButton(
                onPressed: () => {nav.toPath("/validate")},
                color: Styles.actionPrimary,
                child: const Text("Validate Data", style: Styles.actionText)),
            const Spacer(),
            // CupertinoButton(
            //     onPressed: () => nav.toPath("/video"),
            //     color: Styles.comingSoonColor,
            //     child: const Text(
            //       "Test Video",
            //       style: Styles.error,
            //     )),
          ],
        ),
      ),
    );
  }
}
