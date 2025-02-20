import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/profile/view/profiles_list.dart';

class ProfilesView extends StatelessWidget {
  const ProfilesView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: BaseView(
        child: ProfilesList(
          (profile) => {
            AppNav(context).toPath(path: "/profile", args: profile),
          },
        ),
      ),
    );
  }
}
