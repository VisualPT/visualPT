import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/auth/auth_bloc.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/app_nav.dart';
import 'package:visualpt/views/components/_components.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      pageTitle: "Settings",
      child: Stack(
        children: [
          const ViewBackground(),
          Center(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoButton.filled(
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context)
                            .add(AuthDisconnect());
                        AppNav().setAuth(context);
                      },
                      child: const Text("Sign Out"),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
