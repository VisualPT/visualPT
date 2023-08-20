import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/utils/auth_utils.dart';

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

  bool validateLogin({required void Function(String) onInvalid}) {
    return AuthUtils.validateEmail(email) == null &&
        AuthUtils.validatePassword(password) == null;
  }

  bool validateSignup({required void Function(String) onInvalid}) {
    validateLogin(onInvalid: onInvalid);
    if (password != confirmPassword) {
      onInvalid("Passwords do not match");
      return false;
    }
    return true;
  }

  bool validateReset() {
    if (password != confirmPassword) {
      return false;
    }
    return true;
  }

  Future<AuthSession?> fetch() async {
    AuthSession? session;
    try {
      session = await Amplify.Auth.fetchAuthSession();
    } catch (e) {
      log("fetch function failed to return a AuthSession with error $e");
    }
    return session;
  }

  Future<List<AuthUserAttribute>> fetchAttributes() async {
    return await Amplify.Auth.fetchUserAttributes();
  }

  //Returns true if the user is successfully signed in, false if the user needs to validate with a code, and throws if there is any other error (to be caught by AuthError)
  Future<String> completeLogin() async {
    log("Logging in...");
    try {
      final result =
          await Amplify.Auth.signIn(username: email, password: password);
      switch (result.nextStep.signInStep) {
        case AuthSignInStep.confirmSignInWithSmsMfaCode:
          return "SMS code validation required";
        case AuthSignInStep.confirmSignInWithNewPassword:
          return "New password required";
        case AuthSignInStep.confirmSignInWithCustomChallenge:
          return "Custom challenge required";
        case AuthSignInStep.confirmSignUp:
          return "Sign up confirmation required";
        case AuthSignInStep.resetPassword:
          return "Password reset required";
        case AuthSignInStep.done:
          return "done";
      }
    } on UserNotFoundException {
      throw ("User was not found");
    } on UserNotConfirmedException {
      throw ("User was not created");
    } on PasswordResetRequiredException {
      throw ("Password reset required");
    } on Exception catch (e) {
      throw (e.toString());
    }
  }

  Future<bool> completeSignUp() async {
    log("Signing In...");
    try {
      //TODO make this dynamically added soon
      final userAttributes = <CognitoUserAttributeKey, String>{
        CognitoUserAttributeKey.name: "Temp",
        CognitoUserAttributeKey.familyName: "Temp",

        // additional attributes as needed
      };
      final result = await Amplify.Auth.signUp(
          username: email,
          password: password,
          options: SignUpOptions(userAttributes: userAttributes));
      switch (result.nextStep.signUpStep) {
        case AuthSignUpStep.confirmSignUp:
          return false;
        case AuthSignUpStep.done:
          return true;
      }
    } on UsernameExistsException {
      throw ("User already exists");
    } on InvalidParameterException {
      throw ("Invalid parameters");
    } on PasswordResetRequiredException {
      throw ("Password reset required");
    } on Exception {
      throw ("User was not signed up");
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

  Future<ResetPasswordResult> resetPassword() async {
    return await Amplify.Auth.resetPassword(
      username: email,
    );
  }

  Future<ResetPasswordResult> confirmResetPassword() async {
    return await Amplify.Auth.confirmResetPassword(
      username: email,
      newPassword: password,
      confirmationCode: confirmCode,
    );
  }

  Future<void> signOut() async {
    Amplify.Auth.signOut();
  }
}
