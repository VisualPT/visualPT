import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/providers/_providers.dart';
import 'package:visualpt/service/auth_service.dart';
import 'package:visualpt/utils/auth_utils.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/app_nav.dart';
import '../providers/auth_provider.dart';
import 'components/_components.dart';

//TODO: Create some animations between auth states
class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  //TODO BLOC FORM WHEN MVP IS DONE
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseView(
        pageTitle: "Welcome to VisualPT",
        child: AuthProvider(
          getProviders: (context) =>
              BlocProviders(context: context, auth: true, user: true),
          onSignUp: (context, state) => signupForm(context, state),
          onLogIn: (context, state) => loginForm(context, state),
          onEmail: (context, state) => emailForm(context, state),
          onValidate: (context, state) => validationForm(context, state),
          onReset: (context, state) => resetForm(context, state),
          onLoad: (context, state) => AppLoading(message: state.message),
          onSuccess: (context, state) {
            AppNav().setHome(context);
            return const AppLoading(message: "Successful Auth");
          },
          onError: (context, state) => authError(context, state.error),
        ));
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

  Widget emailForm(BuildContext context, AuthEmail state) {
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

  Widget validationForm(BuildContext context, AuthValidate state) {
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
                BlocProvider.of<AuthBloc>(context).add(AuthForgot());
              }),
        ),
      ],
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
            child: Text("Retry"),
            onPressed: () =>
                {BlocProvider.of<AuthBloc>(context).add(AuthToggle())},
          )
        ],
      ))),
    );
  }
}
