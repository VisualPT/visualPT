import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/_core.dart';

class AuthView extends StatelessWidget {
  const AuthView(this.app, {super.key});

  final CupertinoApp app;

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
        switch (state.currentStep) {
          case AuthenticatorStep.signIn:
            return CustomScaffold(
              state: state,
              body: SignInForm(),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  Button(
                    onPressed: () => state.changeStep(
                      AuthenticatorStep.signUp,
                    ),
                    text: 'Sign Up',
                  ),
                ],
              ),
            );
          case AuthenticatorStep.signUp:
            return CustomScaffold(
              state: state,
              body: SignUpForm(),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  Button(
                    onPressed: () => state.changeStep(
                      AuthenticatorStep.signIn,
                    ),
                    text: 'Sign In',
                  ),
                ],
              ),
            );
          case AuthenticatorStep.confirmSignUp:
            return CustomScaffold(
              state: state,
              body: ConfirmSignUpForm(),
            );
          case AuthenticatorStep.resetPassword:
            return CustomScaffold(
              state: state,
              body: ResetPasswordForm(),
            );
          case AuthenticatorStep.confirmResetPassword:
            return CustomScaffold(
              state: state,
              body: const ConfirmResetPasswordForm(),
            );
          default:
            return null;
        }
      },
      child: app,
    );
  }
}

/// A widget that displays a logo, a body, and an optional footer.
class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.state,
    required this.body,
    this.footer,
  });

  final AuthenticatorState state;
  final Widget body;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return BaseView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // App logo
                const Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: Center(
                      child: Image(image: AssetImage(Styles.mainIconpath))),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: body,
                ),
                if (footer != null) footer!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
