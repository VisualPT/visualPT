import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/views/_views.dart';
import 'components/_components.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final GlobalKey<ShakerState> _shakeKey = GlobalKey<ShakerState>();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: BaseView(
        pageTitle: "Save clicks and minutes",
        //TODO print debug to figure out why this shit broke
        child: BlocProvider(
          create: (context) => AuthBloc(),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (state is AuthSuccess) {
                  //Sync with Amplify services
                  context
                      .read<AuthBloc>()
                      .close(); //TODO save auth data before closing
                  Navigator.popAndPushNamed(context, "/home");
                } else if (state is AuthError) {
                  _shakeKey.currentState?.shake();
                }
              });
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

  Widget loginForm(BuildContext context) {
    return Shaker(
      key: _shakeKey,
      child: Column(
        children: [
          //TODO stylize for ciewability
          CupertinoButton(
            color: Styles.actionSecondary,
            child: const Text(
              "Sign up",
              style: Styles.subactionText,
            ),
            onPressed: () => addAuthEvent(context, event: AuthToggle()),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("or Access your workflows"),
          ),
          const AuthInput(AuthDataType.email),
          const AuthInput(AuthDataType.password, obscure: true),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width / 2,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Styles.actionPrimary),
                  child: const Text(
                    "Log In",
                    style: Styles.actionText,
                  ),
                ),
                onTap: () => addAuthEvent(context)),
          )
        ],
      ),
    );
  }

  Widget signupForm(BuildContext context) {
    return Shaker(
      key: _shakeKey,
      child: Column(
        children: [
          CupertinoButton(
            color: Styles.actionSecondary,
            child: const Text("Log in", style: Styles.subactionText),
            onPressed: () => addAuthEvent(context, event: AuthToggle()),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("or Rethink your workflows"),
          ),
          const AuthInput(AuthDataType.email),
          const AuthInput(AuthDataType.password, obscure: true),
          const AuthInput(AuthDataType.confirmPassword, obscure: true),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.width / 2,
                width: MediaQuery.of(context).size.width / 2,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Styles.actionPrimary),
                child: const Text(
                  "Sign Up",
                  style: Styles.actionText,
                ),
              ),
              onTap: () => addAuthEvent(context),
            ),
          )
        ],
      ),
    );
  }

  ///If event is null, [AuthAttempt] is assumed and [AuthData] is passed from the bloc
  void addAuthEvent(BuildContext context, {AuthEvent? event}) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    event == null
        ? authBloc.add(AuthAttempt(authData: authBloc.authData))
        : authBloc.add(event);
  }
}
