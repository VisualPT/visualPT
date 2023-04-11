import 'package:flutter/cupertino.dart';
import 'package:visualpt/models/ModelProvider.dart';

import '../styles.dart';

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
                borderRadius: BorderRadius.circular(10.0),
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
