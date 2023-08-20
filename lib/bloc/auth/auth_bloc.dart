import 'dart:async';
import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/models/User.dart';
import 'package:visualpt/service/auth_service.dart';
import 'package:visualpt/service/user_service.dart';
import 'package:visualpt/views/components/_components.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserService userService = UserService();
  late GlobalKey<ShakerState> shake; //For invalid response purposes
  late AuthService auth = AuthService();
  AuthBloc() : super(const AuthSignUp()) {
    on<AuthAuto>(_onAuto);
    on<AuthToggle>(_onToggle);
    on<AuthAttempt>(_onAttempt);
    on<AuthConfirm>(_onConfirm);
    on<AuthForgot>(_onForgot);
    on<AuthConfirmedForgot>(_onConfirmedForgot);
    on<AuthRestore>(_onRestore);
    on<AuthDisconnect>(_onDisconnect);
  }

  FutureOr<void> _onAuto(AuthAuto event, Emitter<AuthState> emit) async {
    log("Attempting auto auth");
    try {
      final session = await auth.fetch();
      log(session.toString(), name: "Session");
      if (session != null && session.isSignedIn) {
        log("User is signed in", name: "Auto Auth");
        final user = await userService.setUser();
        emit(AuthSuccess(user: user));
      }
      log("User is not signed in", name: "Auto Auth");
    } catch (e) {
      emit(AuthError(error: Exception("Failed to auto auth")));
    }
  }

  void _onToggle(AuthToggle event, Emitter<AuthState> emit) {
    if (state is AuthSignUp) {
      emit(const AuthLogIn());
    } else {
      emit(const AuthSignUp());
    }
  }

  void _onAttempt(AuthAttempt event, Emitter<AuthState> emit) async {
    if (state is AuthLogIn) {
      emit(const AuthLoad(message: "Logging in..."));

      try {
        auth.validateLogin(
            onInvalid: (message) => emit(AuthLogIn(message: message)));
        final result = await auth.completeLogin();
        //TODO check if the user has verified their email
        if (result == "done") {
          final user = await userService.setUser();
          emit(AuthSuccess(user: user));
          return;
        } else {
          emit(AuthValidate(message: result));
          return;
        }
      } catch (e) {
        emit(AuthLogIn(message: e.toString()));
      }
    } else if (state is AuthSignUp) {
      emit(const AuthLoad(message: "Signing up..."));
      try {
        auth.validateSignup(
            onInvalid: (message) => emit(AuthLogIn(message: message)));
        final result = await auth.completeSignUp();
        if (result) {
          final user = await userService.setUser();
          emit(AuthSuccess(user: user));
          return;
        } else {
          emit(const AuthValidate());
          return;
        }
      } catch (e) {
        emit(AuthSignUp(message: e.toString()));
      }
    } else {
      emit(AuthError(error: Exception("AuthAttempt: Invalid State $state")));
    }
  }

  FutureOr<void> _onConfirm(AuthConfirm event, Emitter<AuthState> emit) async {
    emit(const AuthLoad(message: "Confirming code..."));
    try {
      final result = await auth.confirmSignUpCode();
      final response = await auth.completeLogin();
      if (result.isSignUpComplete && response == "done") {
        final user = await userService.setUser();
        emit(AuthSuccess(user: user));
      } else {
        emit(AuthValidate(message: response));
      }
    } on CodeMismatchException {
      emit(const AuthValidate(message: "Invalid code"));
    } catch (e) {
      emit(AuthError(error: Exception("Failed to confirm code")));
    }
  }

  FutureOr<void> _onForgot(AuthForgot event, Emitter<AuthState> emit) {
    emit(const AuthEmail());
  }

  FutureOr<void> _onConfirmedForgot(
      AuthConfirmedForgot event, Emitter<AuthState> emit) async {
    emit(const AuthLoad(message: "Checking email..."));
    final result = await auth.resetPassword();
    switch (result.nextStep.updateStep) {
      case AuthResetPasswordStep.confirmResetPasswordWithCode:
        final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
        emit(AuthReset(
            message: "Code sent to ${codeDeliveryDetails.destination}"));
        break;
      case AuthResetPasswordStep.done:
        emit(const AuthSignUp());
    }
  }

  FutureOr<void> _onRestore(AuthRestore event, Emitter<AuthState> emit) async {
    emit(const AuthLoad(message: "Resetting password..."));
    try {
      if (!auth.validateReset()) {
        emit(const AuthReset(message: "Passwords do not match"));
        return;
      }
      final result = await auth.confirmResetPassword();
      if (result.isPasswordReset) {
        await auth.completeLogin();
        final user = await userService.setUser();
        emit(AuthSuccess(user: user));
      } else {
        emit(const AuthReset(message: "Failed to reset password"));
      }
    } catch (e) {
      emit(AuthReset(message: e.toString()));
    }
  }

  FutureOr<void> _onDisconnect(
      AuthDisconnect event, Emitter<AuthState> emit) async {
    emit(const AuthLoad(message: "Disconnecting..."));
    try {
      await auth.signOut();
      emit(const AuthSignUp());
    } catch (e) {
      emit(AuthError(error: Exception("Failed to disconnect")));
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
}
