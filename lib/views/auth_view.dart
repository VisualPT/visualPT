import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/views/styles.dart';
import '../bloc/bloc.dart';
import 'base_view.dart';
import 'components/components.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: BaseView(
        pageTitle: "Save clicks and minutes",
        child: BlocProvider(
          create: (context) => AuthBloc(),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccess) {
                Navigator.pushNamed(context, "/home");
              } else if (state is AuthError) {
                // showCupertinoDialog(
                //   context: context,
                //   builder: (context) => CupertinoAlertDialog(
                //     title: const Text(
                //       "Uh oh...",
                //       style: Styles.defaultTitleOverride,
                //     ),
                //     content: Column(
                //       children: [
                const Text(
                  "An error has occured",
                );
                //         const Text(
                //           "We got the following error message:",
                //         ),
                //         Text(state.message)
                //       ],
                //     ),
                //   ),
                // );
              }

              if (state is AuthSignUp) {
                return signupForm(context);
              } else {
                return loginForm(context);
              }
            },
          ),
        ),
      ),
    );
  }
}

Widget loginForm(BuildContext context) {
  return Column(
    children: [
      //TODO stylize for ciewability
      CupertinoButton(
        child: Text("Sign up"),
        onPressed: () => addAuthEvent(context, event: AuthToggle()),
      ),
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Access your workflows"),
      ),
      const AuthInput(AuthDataType.email),
      const AuthInput(AuthDataType.password, obscure: true),
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
            onTap: () => addAuthEvent(context)),
      )
    ],
  );
}

Widget signupForm(BuildContext context) {
  return Column(
    children: [
      CupertinoButton(
        child: Text("Log in"),
        onPressed: () => addAuthEvent(context, event: AuthToggle()),
      ),
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Rethink your workflows"),
      ),
      const AuthInput(AuthDataType.email),
      const AuthInput(AuthDataType.password, obscure: true),
      const AuthInput(AuthDataType.confirmPassword, obscure: true),
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
              "Sign Up",
              style: TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          onTap: () => addAuthEvent(context),
        ),
      )
    ],
  );
}

///If event is null, [AuthAttempt] is assumed and [AuthData] is passed from the bloc
void addAuthEvent(BuildContext context, {AuthEvent? event}) {
  final authBloc = BlocProvider.of<AuthBloc>(context);
  event == null
      ? authBloc.add(AuthAttempt(authData: authBloc.authData))
      : authBloc.add(event);
}
