import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/views/app_nav.dart';


class AuthProvider extends StatefulWidget {
  final void Function(BuildContext) getProviders;
  final Widget Function(BuildContext context, AuthSignUp state) onSignUp;
  final Widget Function(BuildContext context, AuthLogIn state) onLogIn;
  final Widget Function(BuildContext context, AuthValidate state) onValidate;
  final Widget Function(BuildContext context, AuthLoad state) onLoad;
  final Widget Function(BuildContext context, AuthError state) onError;

  const AuthProvider({
    super.key,
    required this.getProviders,
    required this.onSignUp,
    required this.onLogIn,
    required this.onValidate,
    required this.onLoad,
    required this.onError,
  });

  @override
  State<AuthProvider> createState() => AuthProviderState();
}

class AuthProviderState extends State<AuthProvider> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AuthBloc()
              ..add(AuthAuto(onSuccess: () {
                BlocProvider.of<UserBloc>(context).add(UserFetch());
                AppNav().setHome(context);
              }))),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          widget.getProviders(context);
          try {
            if (state is AuthSignUp) {
              return widget.onSignUp(context, state);
            } else if (state is AuthLogIn) {
              return widget.onLogIn(context, state);
            } else if (state is AuthValidate) {
              return widget.onValidate(context, state);
            } else if (state is AuthLoad) {
              return widget.onLoad(context, state);
            } else {
              throw Exception("Undefined State");
            }
          } catch (e) {
            return widget.onError(context, AuthError(error: Exception(e)));
          }
        },
      ),
    );
  }
}
