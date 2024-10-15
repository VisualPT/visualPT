import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/views/app_nav.dart';
import 'package:visualpt/core/views/styles.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';

class AssessmentCard extends StatelessWidget {
  final BaseAssessment assessment;
  const AssessmentCard(
    this.assessment, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final nav = AppNav(context);
    // final isAdmin = (BlocProvider.of<AuthBloc>(context).state as AuthSuccess)
    //         .user
    //         .email
    //         .toLowerCase()
    //         .contains("tim.richardson@fyzicalhq.com") ||
    //     (BlocProvider.of<AuthBloc>(context).state as AuthSuccess)
    //         .user
    //         .email
    //         .toLowerCase()
    //         .contains("charlesrichardsonusa@gmail.com");

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
                        // const Spacer(),
                        // isAdmin
                        //     ? Column(
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: GestureDetector(
                        //               onTap: () => nav.toPath(
                        //                   path: "/validate",
                        //                   args: assessment.type),
                        //               child: Container(
                        //                 padding: const EdgeInsets.all(4.0),
                        //                 decoration: BoxDecoration(
                        //                   color: Styles.actionSecondary
                        //                       .withAlpha(
                        //                           assessment.isAvailable
                        //                               ? 255
                        //                               : 128),
                        //                   border: Border.all(
                        //                     color: Styles.black,
                        //                     width: 1,
                        //                   ),
                        //                   borderRadius: Styles.borderRadiusM,
                        //                 ),
                        //                 child: const Icon(
                        //                   CupertinoIcons.eye,
                        //                   color: Styles.black,
                        //                   size: 60,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //           const Text("Validate",
                        //               style: Styles.heading3)
                        //         ],
                        //       )
                        //     : Container(),
                        // const Spacer(),

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
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color:
                assessment.isAvailable ? Styles.white : Styles.comingSoonColor,
            border: Border.all(
              color: Styles.black,
              width: 1,
            ),
            borderRadius: Styles.borderRadiusM,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          margin: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                  width: MediaQuery.of(context).size.height / 10,
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    child: Image(
                        image: AssetImage(assessment.imagePath),
                        fit: BoxFit.contain,
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                          return ClipRRect(
                            borderRadius: Styles.borderRadiusM,
                            child: child,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const Icon(
                            CupertinoIcons.question_circle_fill,
                            color: Styles.black,
                            size: 60,
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            CupertinoIcons.question_circle_fill,
                            color: Styles.black,
                            size: 60,
                          );
                        }),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(assessment.type.name.replaceAll("_", " "),
                            style: Styles.title),
                        Text(assessment.name, style: Styles.heading3),
                        Text(
                          assessment.normalDuration,
                          style: Styles.body,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                )
              ]),
        ));
  }
}

Widget comingSoon(Widget child) {
  return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(color: Styles.comingSoonColor, child: child));
}
