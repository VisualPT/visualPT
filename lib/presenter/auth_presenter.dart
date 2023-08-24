import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';

//TODO: Add Bloc Listeners in this file

///
/// Provided BackendBloc & AuthBloc
class AuthPresenter extends StatelessWidget {
  final Widget Function(BuildContext context, AuthSignUp state) onSignUp;
  final Widget Function(BuildContext context, AuthLogIn state) onLogIn;
  final Widget Function(BuildContext context, AuthForgot state) onForgot;
  final Widget Function(BuildContext context, AuthCode state) onCode;
  final Widget Function(BuildContext context, AuthReset state) onReset;
  final Widget Function(BuildContext context, AuthLoad state) onLoad;
  final Widget Function(BuildContext context, AuthSuccess state) onSuccess;
  final Widget Function(BuildContext context, AuthError state) onError;

  const AuthPresenter({
    super.key,
    required this.onSignUp,
    required this.onLogIn,
    required this.onForgot,
    required this.onCode,
    required this.onReset,
    required this.onLoad,
    required this.onSuccess,
    required this.onError,
  });
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(AuthAuto());
    //NOTE: AuthBloc is provided at the root of the application (main.dart) to ensure that the user is accessible from anywhere in the app
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          //Solves the issue of bloc rebuilding, and navigation animation running nonstop on AuthSuccess TODO: Find a better solution
          previous != current,
      builder: (context, state) {
        try {
          return switch (state) {
            AuthSignUp() => onSignUp(context, state),
            AuthLogIn() => onLogIn(context, state),
            AuthForgot() => onForgot(context, state),
            AuthCode() => onCode(context, state),
            AuthReset() => onReset(context, state),
            AuthLoad() => onLoad(context, state),
            AuthSuccess() => onSuccess(context, state),
            AuthError() => onError(context, state),
            AuthState() => throw Exception("Auth State: ${state.toString()}"),
          };
        } catch (e) {
          return onError(context, AuthError(error: Exception(e)));
        }
      },
    );
  }
}
