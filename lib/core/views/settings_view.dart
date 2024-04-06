import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt_collector/features/auth/bloc/auth_bloc.dart';
import 'package:visualpt_collector/core/views/_views.dart';
import 'package:visualpt_collector/core/views/app_nav.dart';
import 'package:visualpt_collector/core/views/components/_components.dart';

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
                            .add(const AuthDisconnect());
                        AppNav(context).reset();
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
