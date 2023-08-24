import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/presenter/_presenter.dart';
import 'package:visualpt/service/auth_service.dart';
import 'package:visualpt/utils/auth_utils.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/app_nav.dart';
import 'components/_components.dart';

//TODO: Create some animations between auth states
class AuthView extends StatelessWidget {
  AuthView({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AuthPresenter(
      onSignUp: (context, state) => signupForm(context, state),
      onLogIn: (context, state) => loginForm(context, state),
      onForgot: (context, state) => forgotForm(context, state),
      onReset: (context, state) => resetForm(context, state),
      onCode: (context, state) => codeForm(context, state),
      onSuccess: (context, state) {
        AppNav(context).setHome();
        return const AppLoading(message: "Successful Auth");
      },
      onLoad: (context, state) => AppLoading(message: state.message),
      onError: (context, state) => authError(context, state.error),
    );
  }

//TODO: Create a core form widget that takes in a list of FormInputs

  Widget signupForm(BuildContext context, AuthSignUp state) {
    return SingleChildScrollView(
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
                validator: AuthUtils.validateEmail),
            const FormInput("password",
                authType: AuthDataType.password,
                obscure: true,
                validator: AuthUtils.validatePassword),
            const FormInput("confirm password",
                authType: AuthDataType.confirmPassword,
                obscure: true,
                validator: AuthUtils.validatePassword),
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

  Widget loginForm(BuildContext context, AuthLogIn state) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Accelerate assessments"),
            ),
            const FormInput("email",
                authType: AuthDataType.email,
                inputType: TextInputType.emailAddress,
                validator: AuthUtils.validateEmail),
            const FormInput("password",
                authType: AuthDataType.password,
                obscure: true,
                validator: AuthUtils.validatePassword),
            Text(state.message != null ? state.message! : "",
                style: Styles.error),
            authButtons(context, true),
          ],
        ),
      ),
    );
  }

  Widget forgotForm(BuildContext context, AuthForgot state) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("What is your email?"),
            ),
            const FormInput("email",
                authType: AuthDataType.email,
                inputType: TextInputType.emailAddress,
                validator: AuthUtils.validateEmail),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton(
                  color: Styles.actionPrimary,
                  child: const Text(
                    "Next",
                    style: Styles.subactionText,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _formKey.currentState!.reset();
                      BlocProvider.of<AuthBloc>(context)
                          .add(AuthConfirmedForgot());
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton(
                  color: Styles.actionSecondary,
                  child: const Text(
                    "Go back",
                    style: Styles.subactionText,
                  ),
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(AuthToggle());
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget codeForm(BuildContext context, AuthCode state) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Check your email"),
            ),
            const FormInput("confirmation code",
                authType: AuthDataType.confirmCode,
                validator: AuthUtils.validateCode),
            Text(
              state.message != null ? state.message! : "",
              style: Styles.error,
            ),
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
                  BlocProvider.of<AuthBloc>(context).add(AuthConfirm());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget resetForm(BuildContext context, AuthReset state) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Reset password"),
            ),
            const FormInput("New Password",
                authType: AuthDataType.password,
                validator: AuthUtils.validatePassword),
            const FormInput("Confirm Password",
                authType: AuthDataType.confirmPassword,
                validator: AuthUtils.validatePassword),
            const FormInput("Code (sent to email)",
                authType: AuthDataType.confirmCode,
                validator: AuthUtils.validateCode),
            Text(
              state.message != null ? state.message! : "",
              style: Styles.error,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width / 2,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Styles.actionPrimary),
                  child: const Text("Reset", style: Styles.actionText),
                ),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _formKey.currentState!.reset();
                    log("Auth Data Validated");
                    BlocProvider.of<AuthBloc>(context).add(AuthRestore());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget authError(BuildContext context, Exception? error) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: SingleChildScrollView(
          child: Center(
              child: Column(
        children: [
          Text(error.toString(), style: Styles.error),
          CupertinoButton(
            child: const Text("Retry"),
            onPressed: () =>
                {BlocProvider.of<AuthBloc>(context).add(AuthToggle())},
          )
        ],
      ))),
    );
  }

  Widget authButtons(BuildContext context, bool isLogin) {
    String login = "Log In", signup = "Sign up";
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.width / 3,
              width: MediaQuery.of(context).size.width / 3,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Styles.actionPrimary),
              child: Text(isLogin ? login : signup, style: Styles.actionText),
            ),
            onTap: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _formKey.currentState!.reset();
                log("Auth Data Validated");
                BlocProvider.of<AuthBloc>(context).add(AuthAttempt());
              }
            },
          ),
        ),
        const Text("or"),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CupertinoButton(
              color: Styles.actionPrimary,
              child: Text(
                isLogin ? signup : login,
                style: Styles.subactionText,
              ),
              onPressed: () {
                _formKey.currentState!.reset();
                BlocProvider.of<AuthBloc>(context).add(AuthToggle());
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CupertinoButton(
              color: Styles.actionSecondary,
              child: const Text(
                "Forgot Password",
                style: Styles.subactionText,
              ),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(AuthForgotClicked());
              }),
        ),
      ],
    );
  }
}
