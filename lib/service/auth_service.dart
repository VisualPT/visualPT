import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/bloc/auth/auth_bloc.dart';

enum AuthDataType { email, password, confirmPassword, confirmCode }

class AuthService {
  late String email = "";
  late String password = "";
  late String confirmPassword = "";
  late String confirmCode = "";

  void setEmail(String value) => email = value;
  void setPass(String value) => password = value;
  void setConfirmPass(String value) => confirmPassword = value;
  void setConfirmCode(String value) => confirmCode = value;

  bool isLoginValid() =>
      email.contains(RegExp(
          r'''(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])''')) &&
      password.contains(RegExp(
          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$'));
  bool isSignupValid() => isLoginValid() && password == confirmPassword;
  void debugPrint() =>
      log("email:$email\npass:$password\nconfirm:$confirmPassword\n");

  Future<void> fetchSession({required void Function() onSignedIn}) async {
    log("Observing auth session");
    try {
      await Amplify.Auth.fetchAuthSession()
          .then((value) => value.isSignedIn ? onSignedIn() : null);
    } on Exception catch (e) {
      log("Error fetching session: ${e.toString()}");
    }
  }

  Future<List<AuthUserAttribute>> fetchAttributes() async {
    return await Amplify.Auth.fetchUserAttributes();
  }

  Future<SignInResult> completeLogin() async {
    log("Logging in...");
    try {
      final result =
          await Amplify.Auth.signIn(username: email, password: password);
      return result;
    } on UserNotFoundException {
      throw ("User was not found");
    } on UserNotConfirmedException {
      throw ("User was not created");
    } on PasswordResetRequiredException {
      throw ("Password reset required");
    } on Exception catch (e) {
      log("here");
      throw (e.toString());
    }
  }

  Future<void> handleSignInResult(
      {required SignInResult result,
      required void Function() onValidate,
      required void Function() onSuccess}) async {
    switch (result.nextStep.signInStep) {
      case AuthSignInStep.confirmSignInWithSmsMfaCode:
        log("SMS code sent");
        break;
      case AuthSignInStep.confirmSignInWithNewPassword:
        log("New password required");
        break;
      case AuthSignInStep.confirmSignInWithCustomChallenge:
        log("Custom challenge required");
        break;
        log("Password reset required");
        break;
      case AuthSignInStep.confirmSignUp:
        //TODO: Error prone code. User signed up but not confirmed
        onValidate();
        break;
      case AuthSignInStep.resetPassword:
        // TODO: Handle this case.
        break;
      case AuthSignInStep.done:
        onSuccess();
        break;
    }
  }

  Future<SignUpResult> completeSignUp() async {
    log("Signing In...");
    try {
      //TODO make this dynamically added soon
      final userAttributes = <CognitoUserAttributeKey, String>{
        CognitoUserAttributeKey.name: "Temp",
        CognitoUserAttributeKey.familyName: "Temp",

        // additional attributes as needed
      };
      return await Amplify.Auth.signUp(
          username: email,
          password: password,
          options: SignUpOptions(userAttributes: userAttributes));
    } on UsernameExistsException {
      throw ("User already exists");
    } on InvalidParameterException {
      throw ("Invalid parameters");
    } on PasswordResetRequiredException {
      throw ("Password reset required");
    } on Exception catch (e) {
      throw ("User was not signed up");
    }
  }

  Future<void> handleSignUpResult(
      {required SignUpResult result,
      required void Function() onValidate,
      required void Function() onSuccess}) async {
    switch (result.nextStep.signUpStep) {
      case AuthSignUpStep.confirmSignUp:
        final codeDeliveryDetails = result.nextStep.codeDeliveryDetails;
        onValidate();
        break;
      case AuthSignUpStep.done:
        onSuccess();
        break;
    }
  }

  void handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
    log(
      'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
      'Please check your ${codeDeliveryDetails.deliveryMedium.name} for the code.',
    );
  }

  Future<SignUpResult> confirmSignUpCode() async {
    log("Confirming Sign up with code: $confirmCode");
    return await Amplify.Auth.confirmSignUp(
        username: email, confirmationCode: confirmCode);
  }

  Future<bool> confirmLogInCode() async {
    log("Confirming Log in with code: $confirmCode");
    return await Amplify.Auth.confirmSignIn(confirmationValue: confirmCode)
        .then((value) => value.isSignedIn);
  }

  Future<void> signOut() async {
    Amplify.Auth.signOut();
  }
}
