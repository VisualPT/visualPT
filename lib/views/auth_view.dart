import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/styles.dart';
import 'base_view.dart';
import 'components/components.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: BaseView(
        pageTitle: "Save clicks and minutes",
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.1),
          //TODO AuthBloc Goes Here
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Personalize your experience"),
              ),
              const AuthInput("Username"),
              const AuthInput("Password", obscure: true),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.width / 3,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Styles.actionPrimary),
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    //TODO Authentication State Management!
                    onTap: () => Navigator.pushNamed(context, "/home")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
