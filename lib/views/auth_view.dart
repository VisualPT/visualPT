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

  void onSuccess() {
    BlocProvider.of<UserBloc>(context).add(UserFetch());
    log("Setting home");
    AppNav().setHome(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        pageTitle: "Faster Workflows.",
        child: AuthProvider(
          getProviders: (context) =>
              BlocProviders(context: context, auth: true, user: true),
          onSignUp: (context, state) => signupForm(context, state),
          onLogIn: (context, state) => loginForm(context, state),
          onValidate: (context, state) => validationForm(context, state),
          onLoad: (context, state) => AppLoading(message: state.message),
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
              BlocProvider.of<AuthBloc>(context)
                  .add(AuthConfirm(onSuccess: onSuccess));
            },
          ),
        ),
      ],
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
                //TODO: simplify view add form key to Bloc
                //TODO store data to backend
                BlocProvider.of<AuthBloc>(context).add(AuthAttempt(
                  onSuccess: onSuccess,
                ));
              }
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
              onPressed: () {
                _formKey.currentState!.reset();
                BlocProvider.of<AuthBloc>(context).add(AuthToggle());
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
        child: Text(error.toString(), style: Styles.error),
      )),
    );
  }
}
