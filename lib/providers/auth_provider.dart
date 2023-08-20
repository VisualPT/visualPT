import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';

//TODO: Rename layer to presenters
//TODO: Add Bloc Listeners in this file
class AuthProvider extends StatefulWidget {
  final void Function(BuildContext) getProviders;
  final Widget Function(BuildContext context, AuthSignUp state) onSignUp;
  final Widget Function(BuildContext context, AuthLogIn state) onLogIn;
  final Widget Function(BuildContext context, AuthEmail state) onEmail;
  final Widget Function(BuildContext context, AuthValidate state) onValidate;
  final Widget Function(BuildContext context, AuthReset state) onReset;
  final Widget Function(BuildContext context, AuthLoad state) onLoad;
  final Widget Function(BuildContext context, AuthSuccess state) onSuccess;
  final Widget Function(BuildContext context, AuthError state) onError;

  const AuthProvider({
    super.key,
    required this.getProviders,
    required this.onSignUp,
    required this.onLogIn,
    required this.onEmail,
    required this.onValidate,
    required this.onReset,
    required this.onLoad,
    required this.onSuccess,
    required this.onError,
  });

  @override
  State<AuthProvider> createState() => AuthProviderState();
}

class AuthProviderState extends State<AuthProvider> {
  @override
  Widget build(BuildContext context) {
    //NOTE: AuthBloc is provided at the root of the application (main.dart) to ensure that the user is accessible from anywhere in the app
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          //Solves the issue of bloc rebuilding, and navigation animation running nonstop on AuthSuccess
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        BlocProvider.of<AuthBloc>(context).add(AuthAuto());
        widget.getProviders(context);
        try {
          if (state is AuthSignUp) {
            return widget.onSignUp(context, state);
          } else if (state is AuthLogIn) {
            return widget.onLogIn(context, state);
          } else if (state is AuthEmail) {
            return widget.onEmail(context, state);
          } else if (state is AuthValidate) {
            return widget.onValidate(context, state);
          } else if (state is AuthReset) {
            return widget.onReset(context, state);
          } else if (state is AuthLoad) {
            return widget.onLoad(context, state);
          } else if (state is AuthSuccess) {
            return widget.onSuccess(context, state);
          } else if (state is AuthError) {
            return widget.onError(context, state);
          } else {
            throw Exception("Auth State: ${state.toString()}");
          }
        } catch (e) {
          return widget.onError(context, AuthError(error: Exception(e)));
        }
      },
    );
  }
}
