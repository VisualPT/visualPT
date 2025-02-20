import 'package:flutter/widgets.dart';
import 'package:visualpt/core/view/base_view.dart';
import 'package:visualpt/models/ModelProvider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView(this.profile, {super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return BaseView(
      poppable: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(profile.firstName),
            Text(profile.lastName),
            Text(profile.email),
            Text(profile.dob.getDateTime().toIso8601String()),
            Text(profile.gender.name),
            Text(profile.height.toString()),
            Text(profile.assessments?.length.toString() ?? 'N/A'),
          ],
        ),
      ),
    );
  }
}
