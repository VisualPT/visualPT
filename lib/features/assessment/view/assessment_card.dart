import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/core/views/app_nav.dart';
import 'package:visualpt/core/views/styles.dart';
import 'package:visualpt/features/auth/bloc/auth_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';

class AssessmentCard extends StatelessWidget {
  final String imagePath;
  final AssessmentType assessmentType;
  final String subtitle;
  final bool available;
  const AssessmentCard(
      {Key? key,
      required this.imagePath,
      required this.assessmentType,
      required this.subtitle,
      this.available = true})
      : super(key: key);

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () => available
            ? Navigator.pushNamed(context, "/assessment",
                arguments: assessmentType)
            : null,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.height / 4,
            child: Container(
              decoration: BoxDecoration(
                color:
                    available ? CupertinoColors.white : Styles.comingSoonColor,
                borderRadius: Styles.borderRadiusM,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image(
                  image: AssetImage(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(assessmentType.name,
                  style: available ? Styles.title : Styles.comingSoonTitle),
              Text(subtitle,
                  style:
                      available ? Styles.subtitle : Styles.comingSoonSubtitle)
            ],
          ),
          Center(
              child: isAdmin && available
                  ? CupertinoButton(
                      onPressed: () =>
                          {nav.toPath(path: "/validate", args: assessmentType)},
                      color: Styles.actionSecondary,
                      child: const Text("Validate", style: Styles.subtitle))
                  : Container())
        ]),
      ),
    );
  }
}

Widget comingSoon(Widget child) {
  return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(color: Styles.comingSoonColor, child: child));
}
