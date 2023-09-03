import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/app_nav.dart';
import '../bloc/_bloc.dart';
import 'components/_components.dart';

class HomeView extends StatelessWidget {
  const HomeView(this.isDemo, {super.key});
  final bool isDemo;

  @override
  Widget build(BuildContext context) {
    final nav = AppNav(context);

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
                      imagePath: Styles.gvLogoPath,
                      assessmentType: AssessmentType.GAIT,
                      subtitle: "5 minutes",
                      available: false,
                    ),
                  ],
                ),
              ),
            ),

            isDemo
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoButton(
                        onPressed: () => nav.toPath(path: "/video", args: {
                              "storageAccess":
                                  (BlocProvider.of<AuthBloc>(context).state
                                              as AuthSuccess)
                                          .user
                                          .email !=
                                      'gaitertech@gmail.com',
                              "onComplete": (Segment s) => {nav.back()}
                            }),
                        color: Styles.actionPrimary,
                        child: const Text(
                          "Collect Data ",
                          style: Styles.actionText,
                        )),
                  ),

            isDemo
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoButton(
                        onPressed: () => {nav.toPath(path: "/validate")},
                        color: Styles.actionPrimary,
                        child: const Text("Validate Data",
                            style: Styles.actionText)),
                  ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
