import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/auth/bloc/auth_bloc.dart';
import 'package:visualpt/features/auth/service/auth_service.dart';
import 'package:visualpt/features/auth/service/auth_utils.dart';
import 'package:visualpt/features/auth/view/auth_presenter.dart';
import 'package:visualpt/core/views/_views.dart';
import 'package:visualpt/core/views/components/_components.dart';

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
              child: Text("Lets get you started", style: Styles.heading1),
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
              child: Text("Welcome back", style: Styles.heading1),
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
                      BlocProvider.of<AuthBloc>(context)
                          .add(const AuthConfirmedForgot());
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
                    BlocProvider.of<AuthBloc>(context).add(const AuthToggle());
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
                  BlocProvider.of<AuthBloc>(context).add(const AuthConfirm());
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
              child: CupertinoButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    log("Auth Data Validated");
                    BlocProvider.of<AuthBloc>(context).add(const AuthRestore());
                  }
                },
                child: const Text("Reset", style: Styles.actionText),
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
                {BlocProvider.of<AuthBloc>(context).add(const AuthToggle())},
          )
        ],
      ))),
    );
  }

  Widget authButtons(BuildContext context, bool isLogin) {
    String login = "Log In", signup = "Sign up";
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CupertinoButton(
                color: Styles.actionPrimary,
                child: Text(
                  isLogin ? login : signup,
                  style: Styles.actionText,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    log("Auth Data Validated");
                    BlocProvider.of<AuthBloc>(context).add(isLogin
                        ? const AuthAttemptLogIn()
                        : const AuthAttemptSignUp());
                  }
                }),
          ),
          const Spacer(),
          Text(isLogin ? "Don't have an account?" : "Already have an account?"),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CupertinoButton(
                color: Styles.actionSecondary,
                child: Text(
                  isLogin ? signup : login,
                  style: Styles.subactionText,
                ),
                onPressed: () {
                  _formKey.currentState!.reset();
                  BlocProvider.of<AuthBloc>(context).add(const AuthToggle());
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
                  BlocProvider.of<AuthBloc>(context)
                      .add(const AuthForgotClicked());
                }),
          ),
        ],
      ),
    );
  }
}
