import 'dart:async';
import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/service/auth_service.dart';
import 'package:visualpt/service/user_service.dart';
import 'package:visualpt/views/components/_components.dart';

part 'auth_event.dart';
part 'auth_state.dart';

enum AuthMethod { signUp, logIn }

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthMethod method = AuthMethod.signUp;
  late GlobalKey<ShakerState> shake; //For invalid response purposes
  late AuthService auth = AuthService();
  AuthBloc() : super(AuthSignUp()) {
    on<AuthAuto>(_onAuto);
    on<AuthToggle>(_onToggle);
    on<AuthAttempt>(_onAttempt);
    on<AuthConfirm>(_onConfirm);
  }

  FutureOr<void> _onAuto(AuthAuto event, Emitter<AuthState> emit) async {
    log("Attempting auto auth");
    //TODO Get all the users data and put it in a singleton
    await auth.fetchSession(onSignedIn: () async {
      //TODO Ensure that the user is confirmed
      await userService.setUser();
      event.onSuccess();
    });
  }

  void _onToggle(AuthToggle event, Emitter<AuthState> emit) {
    if (state is AuthSignUp) {
      emit(AuthLogIn());
      method = AuthMethod.logIn;
    } else {
      emit(AuthSignUp());
      method = AuthMethod.signUp;
    }
  }

  void _onAttempt(AuthAttempt event, Emitter<AuthState> emit) async {
    if (state is AuthLogIn && auth.isLoginValid()) {
      try {
        final result = await auth.completeLogin();
        //TODO check if the user has verified their email
        auth.handleSignInResult(
            result: result,
            onValidate: () => emit(AuthValidate()),
            onSuccess: event.onSuccess);
      } catch (e) {
        emit(AuthLogIn(message: e.toString()));
      }
    } else if (state is AuthSignUp && auth.isSignupValid()) {
      try {
        final result = await auth.completeSignUp();
        auth.handleSignUpResult(
            result: result,
            onValidate: () => emit(AuthValidate()),
            onSuccess: event.onSuccess);
      } catch (e) {
        emit(AuthSignUp(message: e.toString()));
      }
    } else {
      shake.currentState?.shake();
    }
  }

  FutureOr<void> _onConfirm(AuthConfirm event, Emitter<AuthState> emit) async {
    if (method == AuthMethod.signUp) {
      log("Attempting to confirm signup");
      final result = await auth.confirmSignUpCode();
      auth.handleSignUpResult(
          result: result,
          onValidate: () => emit(AuthValidate()),
          onSuccess: event.onSuccess);
    } else {
      event.onSuccess();

      // await auth.confirmLogInCode().then((value) => value
      //     ? emit(AuthSuccess())
      //     : AuthError("The code entered was invalid"));
    }
  }

  void setData(AuthDataType type, String data) {
    if (type == AuthDataType.email) {
      auth.setEmail(data);
    } else if (type == AuthDataType.password) {
      auth.setPass(data);
    } else if (type == AuthDataType.confirmPassword) {
      auth.setConfirmPass(data);
    } else if (type == AuthDataType.confirmCode) {
      auth.setConfirmCode(data);
    }
  }

  void setShake(GlobalKey<ShakerState> shakeKey) {
    shake = shakeKey;
  }

  // void clearInput(TextEditingController controller) {
  //   print("Attempting to Clear");
  //   if (state is AuthError) {
  //     controller.clear();
  //   }
  // }
}
