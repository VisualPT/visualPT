import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/_core.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      pageTitle: "Settings",
      child: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Button(
                        text: "Delete Account",
                        onPressed: () => onDeleteAccount(context))),
                const Padding(
                    padding: EdgeInsets.all(8.0), child: SignOutButton()),
                const AppVersion()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

onDeleteAccount(BuildContext context) {
  //Enqueue a prompt window to confirm account deletion
  appDialog(
      context: context,
      title: "Delete Account",
      content:
          "Are you sure you want to delete your account? This action cannot be undone.",
      primaryAction: "Delete",
      secondaryAction: "Cancel",
      secondaryCallback: () => {
            //Do not delete, pop the dialog
            Navigator.pop(context)
          },
      primaryCallback: () => deleteUser());
}
