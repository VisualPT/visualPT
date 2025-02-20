import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/_core.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseView(
      pageTitle: "Settings",
      child: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(8.0), child: SignOutButton()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
