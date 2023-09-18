import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/auth_service.dart';
import 'package:visualpt/utils/auth_utils.dart';

class AuthRepository {
  AuthRepository();
  final _authService = AuthService();
  late String email = "";
  late String password = "";
  late String confirmPassword = "";
  late String code = "";
  bool isSignedIn = false;
  bool launchStatusChecked = false;

  void setEmail(String value) => email = value;
  void setPass(String value) => password = value;
  void setConfirmPass(String value) => confirmPassword = value;
  void setConfirmCode(String value) => code = value;

  Future<bool> checkLaunchStatus() async {
    final session = await _authService.fetchSession();
    log("Session has returned with the values $session", name: "Launch Status");
    isSignedIn = session.isSignedIn;
    launchStatusChecked = true;
    return session.isSignedIn;
  }

  bool validateLogin() {
    return AuthUtils.validateEmail(email) == null &&
        AuthUtils.validatePassword(password) == null;
  }

  bool validateSignup() {
    validateLogin();
    if (password != confirmPassword) {
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

/////////////////////////////// AUTH USER FUNCTIONS ///////////////////////////////

  //Returns true if the user is successfully signed in, false if the user needs to validate with a code, and throws if there is any other error (to be caught by AuthError)
  Future<String> completeLogin() async {
    log("Logging in...");
    try {
      final result =
          await _authService.signIn(username: email, password: password);
      switch (result.nextStep.signInStep) {
        case AuthSignInStep.continueSignInWithMfaSelection:
          return "MFA selection required";
        case AuthSignInStep.continueSignInWithTotpSetup:
          return "TOTP setup required";
        case AuthSignInStep.confirmSignInWithTotpMfaCode:
          return "TOTP code validation required";
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
          isSignedIn = true;
          return "done";
      }
    } on UserNotFoundException {
      throw ("User was not found");
    } on UserNotConfirmedException {
      throw ("User was not created");
    } on PasswordResetRequiredException {
      throw ("Password reset required");
    } catch (e, s) {
      log(e.toString(), name: "Login In Error");
      log(s.toString(), name: "Login Stack Trace");
      rethrow;
    }
  }

  Future<bool> completeSignUp() async {
    log("Signing In...");
    try {
      //TODO make this dynamically added soon
      final userAttributes = <CognitoUserAttributeKey, String>{
        CognitoUserAttributeKey.name: "Temp",
        CognitoUserAttributeKey.familyName: "Temp",
      };
      final options = SignUpOptions(userAttributes: userAttributes);
      final result = await _authService.signUp(email, password, options);
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

  Future<SignUpResult> confirmSignUpCode() async {
    log("Confirming Sign up with code: $code");
    return await _authService.confirmSignUp(email, code);
  }

  Future<bool> confirmLogInCode() async {
    log("Confirming Log in with code: $code");
    final result = await _authService.confirmSignIn(code);
    isSignedIn = result.isSignedIn;
    return result.isSignedIn;
  }

  Future<ResetPasswordResult> resetPassword() async {
    return await _authService.resetPassword(email);
  }

  Future<ResetPasswordResult> confirmResetPassword() async {
    return await _authService.confirmResetPassword(email, password, code);
  }

  Future<void> signOut() async {
    isSignedIn = false;
    _authService.signOut();
  }

  Future<User> setUser() async {
    final userData = await _authService.fetchUser();
    log("userData has returned with the values $userData");
    late String email, firstName, lastName, status = "MALE";

    for (var element in userData) {
      switch (element.userAttributeKey.key) {
        case "email":
          email = element.value;
          break;
        case "name":
          firstName = element.value;
          break;
        case "family_name":
          lastName = element.value;
          break;
        case "status":
          status = element.value;
          break;
      }
    }
    final user = await fetchUserByEmail(email);
    return user ??
        await createUser(email, firstName, lastName, userStatusParse(status));
  }

  /////////////////////////////// DATASTORE USER FUNCTIONS ///////////////////////////////

  Future<User?> fetchUserByEmail(String email) async {
    try {
      return await _authService.read({"email": email});
    } catch (e) {
      log("fetchByUserEmail function failed to return a User with error $e");
      return null;
    }
  }

  Future<User> createUser(
    String email,
    String firstName,
    String lastName,
    UserStatus status,
  ) async {
    final User user = User(
      email: email,
      first_name: firstName,
      last_name: lastName,
      status: status,
    );
    _authService.create(user);
    return user;
  }

  UserStatus userStatusParse(String text) {
    log("userStatusParse function called with text $text");
    switch (text) {
      case "MALE":
        return UserStatus.ADMIN;
      default:
        log("Incorrect userStatus");
        return UserStatus.ADMIN;
    }
  }
}
