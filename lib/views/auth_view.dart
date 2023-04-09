import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/service/auth_service.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/app_nav.dart';
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
      pageTitle: "Faster Workflows.",
      //TODO print debug to figure out why this shit broke
      child: BlocProvider(
        create: (context) => AuthBloc()
          ..add(AuthAuto(onSuccess: () {
            BlocProvider.of<UserBloc>(context).add(UserFetch());
            AppNav().setHome(context);
          }))
          ..setShake(_shakeKey),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSignUp) {
              return signupForm(context, state);
            } else if (state is AuthLogIn) {
              return loginForm(context, state);
            } else if (state is AuthValidate) {
              return validationForm(context, state);
            }
            return const AppLoading();
          },
        ),
      ),
    );
  }

  //TODO fortify validators
  Widget loginForm(BuildContext context, AuthLogIn state) {
    return Shaker(
      key: _shakeKey,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Access your accelerators"),
            ),
            const FormInput("email",
                authType: AuthDataType.email,
                inputType: TextInputType.emailAddress,
                validator: validateEmail),
            const FormInput("password",
                authType: AuthDataType.password,
                obscure: true,
                validator: validatePassword),
            Text(state.message != null ? state.message! : "",
                style: Styles.error),
            authButtons(context, true),
          ],
        ),
      ),
    );
  }

  //TODO fortify validators
  Widget signupForm(BuildContext context, AuthSignUp state) {
    return Shaker(
      key: _shakeKey,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Speed things up, just a few fields first"),
            ),
            const FormInput("email",
                authType: AuthDataType.email,
                inputType: TextInputType.emailAddress,
                validator: validateEmail),
            const FormInput("password",
                authType: AuthDataType.password,
                obscure: true,
                validator: validatePassword),
            const FormInput("confirm password",
                authType: AuthDataType.confirmPassword,
                obscure: true,
                validator: validatePassword),
            Text(
              state.message != null ? state.message! : "",
              style: Styles.error,
            ),
            authButtons(context, false),
          ],
        ),
      ),
    );
  }

  //TODO fortify validators
  Widget validationForm(BuildContext context, AuthValidate state) {
    return Shaker(
      key: _shakeKey,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Check your email"),
            ),
            const FormInput("confirmation code",
                authType: AuthDataType.confirmCode, validator: validateCode),
            Text(
              state.message != null ? state.message! : "",
              style: Styles.error,
            ),
            confirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget confirmButton(BuildContext context) {
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
              child: const Text("Confirm", style: Styles.actionText),
            ),
            onTap: () {
              BlocProvider.of<AuthBloc>(context).add(AuthConfirm(onSuccess: () {
                BlocProvider.of<UserBloc>(context).add(UserFetch());
                AppNav().setHome(context);
              }));
            },
          ),
        ),
      ],
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
              //Add a loading state
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _formKey.currentState!.reset();
                log("Auth Data Validated");
                //TODO store data to backend
              }
              BlocProvider.of<AuthBloc>(context).add(AuthAttempt(
                onSuccess: () {
                  BlocProvider.of<UserBloc>(context).add(UserFetch());
                  AppNav().setHome(context);
                },
              ));
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
            onPressed: () =>
                BlocProvider.of<AuthBloc>(context).add(AuthToggle()),
          ),
        ),
      ],
    );
  }
}

String? validateEmail(String? string) => string != null
    ? string.contains(RegExp(
            r'''(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])'''))
        ? null
        : "Please provide a valid email"
    : "Please provide a valid email";

//TODO explain what a valid password consists of
String? validatePassword(String? string) => string != null
    ? string.contains(RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$'))
        ? null
        : "Please provide a valid password"
    : "Please provide a valid password";

String? validateCode(String? string) => string != null
    ? string.contains(RegExp(r'^[0-9]{6}$'))
        ? null
        : "Please provide a six digit code"
    : "Please provide a six digit code";
