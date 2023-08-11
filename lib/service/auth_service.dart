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

  //TODO: set new validation regex
  //The string must contain at least one lowercase alphabetical character ((?=.*[a-z])).
  //The string must contain at least one uppercase alphabetical character ((?=.*[A-Z])).
  //The string must contain at least one numerical character ((?=.*\d)).
  //The string must contain at least one of these special characters: @, $, !, %, *, ?, & ((?=.*[@$!%*?&])).
  //The string must be at least 8 characters long and can contain any of the characters specified in the previous conditions ([A-Za-z\d@$!%*?&]{8,}$).
  //If you want to allow any symbol (not just the select ones), you can change [@$!%*?&] to [\p{P}\p{S}]. This would match all punctuation and symbol characters according to the Unicode categories. This would look like:

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

  Future<void> fetchSession(void Function() onSignedIn) async {
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
        //TODO: add case for password reset required
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
    } on Exception {
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
