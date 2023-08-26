import 'dart:developer';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/service/_service.dart';

import '../models/ModelProvider.dart';

enum AuthDataType { email, password, confirmPassword, confirmCode }

class AuthService extends DataStoreService<User> {
  @override
  void create(Model entity) {
    final User user = entity as User;
    log("Saving ${user.toJson()} to DataStore");
    Amplify.DataStore.save(user);
  }

  @override
  Future<User> read(Map<String, dynamic> params) async {
    final email = params["email"];
    final users = await Amplify.DataStore.query(User.classType,
        where: User.EMAIL.eq(email));
    return users.first;
  }

  Future<AuthSession> fetchSession() async {
    return await Amplify.Auth.fetchAuthSession();
  }

  Future<List<AuthUserAttribute>> fetchUser() async {
    return await Amplify.Auth.fetchUserAttributes();
  }

  Future<SignUpResult> signUp(String email, String password, options) async {
    log("Signing up...");
    return await Amplify.Auth.signUp(
        username: email, password: password, options: options);
  }

  Future<SignInResult> signIn(
      {required String username, required String password}) async {
    log("Signing in...");
    return await Amplify.Auth.signIn(
      username: username,
      password: password,
    );
  }

  void handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
    log(
      'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
      'Please check your ${codeDeliveryDetails.deliveryMedium.name} for the code.',
    );
  }

  Future<SignUpResult> confirmSignUp(String email, String code) async {
    log("Confirming Sign up with code: $code");
    return await Amplify.Auth.confirmSignUp(
        username: email, confirmationCode: code);
  }

  Future<SignInResult> confirmSignIn(String code) async {
    log("Confirming Log in with code: $code");
    return await Amplify.Auth.confirmSignIn(confirmationValue: code);
  }

  Future<ResetPasswordResult> resetPassword(String email) async {
    return await Amplify.Auth.resetPassword(
      username: email,
    );
  }

  Future<ResetPasswordResult> confirmResetPassword(
      String email, String password, String code) async {
    return await Amplify.Auth.confirmResetPassword(
      username: email,
      newPassword: password,
      confirmationCode: code,
    );
  }

  Future<void> signOut() async {
    Amplify.Auth.signOut();
  }
}
