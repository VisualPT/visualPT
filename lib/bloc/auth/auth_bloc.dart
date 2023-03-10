import 'dart:async';
import 'dart:developer';

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
      await userService
          .initUser()
          .then((user) => log(user.toString(), name: "Authenticated User"));
      emit(AuthSuccess());
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
      auth.completeLogin();
      log("LogIn Data Validated");
      emit(AuthSuccess());
    } else if (state is AuthSignUp && auth.isSignupValid()) {
      log("SignUp Data Validated");
      auth.completeSignUp();
      emit(AuthValidate());
    } else {
      shake.currentState?.shake();
    }
  }

  FutureOr<void> _onConfirm(event, emit) async {
    if (method == AuthMethod.signUp) {
      await auth.confirmSignUpCode().then((value) => value
          ? emit(AuthSuccess())
          : AuthError("The code entered was invalid"));
    } else {
      emit(AuthSuccess());

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

  setShake(GlobalKey<ShakerState> shakeKey) {
    shake = shakeKey;
  }

  // void clearInput(TextEditingController controller) {
  //   print("Attempting to Clear");
  //   if (state is AuthError) {
  //     controller.clear();
  //   }
  // }
}
