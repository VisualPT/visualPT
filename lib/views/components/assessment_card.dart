import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/components/patient_form.dart';

class AssessmentCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const AssessmentCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PatientForm(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.height / 4,
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image(image: AssetImage(imagePath), fit: BoxFit.contain),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 32)),
                Text(subtitle, style: const TextStyle(fontSize: 24)),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
