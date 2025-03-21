import 'package:flutter/widgets.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/models/ModelProvider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView(this.profile, this.assessments, {super.key});

  final Profile profile;
  final List<Assessment> assessments;

  @override
  Widget build(BuildContext context) {
    return BaseView(
      poppable: true,
      child: SingleChildScrollView(
        child: Column(children: [
          Card(
            child: Column(
              children: [
                Row(
                  children: [
                    const Text("Name:"),
                    Text(profile.firstName),
                    Text(profile.lastName),
                  ],
                ),
                Row(
                  children: [
                    const Text("DOB:"),
                    Text(profile.dob.getDateTime().toIso8601String()),
                  ],
                ),
                Row(
                  children: [
                    const Text("Gender:"),
                    Text(profile.gender.name),
                  ],
                ),
                Row(
                  children: [
                    const Text("Email:"),
                    Text(profile.email),
                  ],
                ),
                Row(
                  children: [
                    const Text("Height:"),
                    Text(profile.height.toString()),
                  ],
                )
              ],
            ),
          ),
          Card(
              child: Column(children: [
            const Text("Assessments"),
            //Make a card here for each unique assessment type that the user has taken
            ...assessments
                .map((assessment) => assessment.type)
                .toSet()
                .map((type) => Column(children: [
                      Row(children: [
                        const Text("ICON"),
                        Button(text: type.name)
                        // Make a card here for each assessment of this type
                      ]),
                      // TODO: implement additional assessment cards here
                    ])),
          ])),
        ]),
      ),
    );
  }
}
