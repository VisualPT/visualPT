import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/_views.dart';
import 'components/_components.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: BaseView(
        pageTitle: "",
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: const [
            AssessmentCard(
                imagePath: Styles.ctsibLogoPath,
                title: "CT-SIB",
                subtitle: "3 minutes"),
            AssessmentCard(
                imagePath: Styles.gvLogoPath,
                title: "Gait Velocity",
                subtitle: "5 minutes"),
          ],
        ),
      ),
    );
  }
}
