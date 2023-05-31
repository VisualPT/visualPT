import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

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

  Future<void> completeLogin() async {
    log("Logging in...");
    try {
      await Amplify.Auth.signIn(username: email, password: password);
    } on UserNotFoundException {
      throw ("User was not found");
      // } on NotAuthorizedException {
      //   throw ("User was not authorized");
    } on UserNotConfirmedException {
      throw ("User was not created");
    } on Exception catch (e) {
      throw ("User was not logged in");
    } on PasswordResetRequiredException {
      //TODO
    }
  }

  void completeSignUp() async {
    log("Signing In...");
    //TODO make this dynamically added soon
    try {
      final userAttributes = <CognitoUserAttributeKey, String>{
        CognitoUserAttributeKey.name: "Temp",
        CognitoUserAttributeKey.familyName: "Temp",

        // additional attributes as needed
      };
      await Amplify.Auth.signUp(
          username: email,
          password: password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));
    } on UsernameExistsException {
      // TODO
    } catch (e) {
      // TODO
    }
  }

  Future<bool> confirmSignUpCode() async {
    log("Confirming Sign up with code: $confirmCode");
    return await Amplify.Auth.confirmSignUp(
            username: email, confirmationCode: confirmCode)
        .then((value) => value.isSignUpComplete);
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
