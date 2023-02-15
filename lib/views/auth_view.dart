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
  //TODO BLOC FORM WHEN MVP IS DONE
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseView(
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
                Navigator.pushReplacementNamed(context, "/home");
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
    );
  }

  Widget loginForm(BuildContext context) {
    return Shaker(
      key: _shakeKey,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Access your workflows"),
            ),
            const FormInput("email",
                authType: AuthDataType.email,
                inputType: TextInputType.emailAddress),
            const FormInput("password",
                authType: AuthDataType.password, obscure: true),
            authButtons(context, true)
          ],
        ),
      ),
    );
  }

  Widget signupForm(BuildContext context) {
    return Shaker(
      key: _shakeKey,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Rethink your workflows"),
            ),
            const FormInput("email",
                authType: AuthDataType.email,
                inputType: TextInputType.emailAddress),
            const FormInput("password",
                authType: AuthDataType.password, obscure: true),
            const FormInput("confirm password",
                authType: AuthDataType.confirmPassword, obscure: true),
            authButtons(context, false)
          ],
        ),
      ),
    );
  }

  Widget authButtons(BuildContext context, bool isLogin) {
    String login = "Log In";
    String signup = "Sign up";
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.width / 2,
              width: MediaQuery.of(context).size.width / 2,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Styles.actionPrimary),
              child: Text(isLogin ? login : signup, style: Styles.actionText),
            ),
            onTap: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                //TODO store data to backend
              }
              addAuthEvent(context);
            },
          ),
        ),
        const Text("or"),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CupertinoButton(
            color: Styles.actionSecondary,
            child: Text(
              isLogin ? signup : login,
              style: Styles.subactionText,
            ),
            onPressed: () => addAuthEvent(context, event: AuthToggle()),
          ),
        ),
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
}
