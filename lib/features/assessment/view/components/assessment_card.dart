import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/core/views/app_nav.dart';
import 'package:visualpt/core/views/styles.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/auth/bloc/auth_bloc.dart';

class AssessmentCard extends StatelessWidget {
  final BaseAssessment assessment;
  const AssessmentCard(
    this.assessment, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nav = AppNav(context);
    final isAdmin = (BlocProvider.of<AuthBloc>(context).state as AuthSuccess)
            .user
            .email
            .toLowerCase()
            .contains("tim.richardson@fyzicalhq.com") ||
        (BlocProvider.of<AuthBloc>(context).state as AuthSuccess)
            .user
            .email
            .toLowerCase()
            .contains("charlesrichardsonusa@gmail.com");

    return GestureDetector(
        onTap: () => showCupertinoModalPopup(
              context: context,
              builder: (context) => Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Styles.white,
                  borderRadius: Styles.borderRadiusM,
                ),
                child: CupertinoScrollbar(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        !assessment.isAvailable
                            ? const Text("Coming Soon",
                                style: Styles.comingSoonHeading3)
                            : Container(),
                        Center(
                          child: Text(
                            assessment.name,
                            style: Styles.heading1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(mainAxisSize: MainAxisSize.max, children: [
                          const Spacer(),
                          Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () => assessment.isAvailable
                                        ? nav.toPath(
                                            path: "/assessment",
                                            args: assessment.type)
                                        : null,
                                    child: Container(
                                      padding: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        color: Styles.actionPrimary.withAlpha(
                                            assessment.isAvailable ? 255 : 128),
                                        border: Border.all(
                                          color: Styles.black,
                                          width: 1,
                                        ),
                                        borderRadius: Styles.borderRadiusM,
                                      ),
                                      child: const Icon(
                                        CupertinoIcons.play_arrow,
                                        color: Styles.white,
                                        size: 60,
                                      ),
                                    ),
                                  )),
                              const Text("Capture", style: Styles.heading3),
                            ],
                          ),
                          const Spacer(),
                          isAdmin
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () => nav.toPath(
                                            path: "/validate",
                                            args: assessment.type),
                                        child: Container(
                                          padding: const EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            color: Styles.actionSecondary
                                                .withAlpha(
                                                    assessment.isAvailable
                                                        ? 255
                                                        : 128),
                                            border: Border.all(
                                              color: Styles.black,
                                              width: 1,
                                            ),
                                            borderRadius: Styles.borderRadiusM,
                                          ),
                                          child: const Icon(
                                            CupertinoIcons.eye,
                                            color: Styles.black,
                                            size: 60,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text("Validate",
                                        style: Styles.heading3)
                                  ],
                                )
                              : Container(),
                          const Spacer(),
                        ]),
                        const SizedBox(height: 20),
                        Text(
                          assessment.details,
                          style: Styles.popupSelectionText,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
        child: Container(
          decoration: BoxDecoration(
            color:
                assessment.isAvailable ? Styles.white : Styles.comingSoonColor,
            border: Border.all(
              color: Styles.black,
              width: 1,
            ),
            borderRadius: Styles.borderRadiusM,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
          margin: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 12,
                  width: MediaQuery.of(context).size.height / 12,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: Styles.borderRadiusM,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Image(
                        image: AssetImage(assessment.imagePath),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(assessment.type.name.replaceAll("_", " "),
                          style: Styles.title),
                      Row(
                        children: [
                          Text(assessment.normalDuration,
                              style: Styles.heading3),
                          //Create a popup similar to the AssessmentInstructions that takes in the assessment.details and displays it on top of the view
                        ],
                      )
                    ],
                  ),
                ),
                const Spacer(),
              ]),
        ));
  }
}

Widget comingSoon(Widget child) {
  return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(color: Styles.comingSoonColor, child: child));
}
