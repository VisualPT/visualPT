import 'dart:async';
import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/features/auth/service/auth_repository.dart';
import 'package:visualpt/features/backend/service/backend_repository.dart';
import 'package:visualpt/models/User.dart';
import 'package:visualpt/features/auth/service/auth_service.dart';
import 'package:visualpt/core/views/components/_components.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._backendRepository, this._authRepository)
      : super(const AuthSignUp()) {
    on<AuthAuto>(_onAuto);
    on<AuthToggle>(_onToggle);
    on<AuthAttemptLogIn>(_onAttemptLogin);
    on<AuthAttemptSignUp>(_onAttemptSignUp);
    on<AuthGuest>(_onGuest);
    on<AuthConfirm>(_onConfirm);
    on<AuthForgotClicked>(_onForgot);
    on<AuthConfirmedForgot>(_onConfirmedForgot);
    on<AuthRestore>(_onRestore);
    on<AuthDisconnect>(_onDisconnect);

    add(const AuthAuto());
    _backendRepository.authEvents.onData((data) async {
      log("${data.type} ${data.payload}", name: "Auth Bloc");
    });
  }
  final BackendRepository _backendRepository;
  final AuthRepository _authRepository;
  late GlobalKey<ShakerState> shake; //For invalid response purposes

  FutureOr<void> _onAuto(AuthAuto event, Emitter<AuthState> emit) async {
    //Check if the user has been logged in on app launch
    try {
      if (!_authRepository.launchStatusChecked) {
        log("Checking launch status", name: "Auto Auth");
        final status = await _authRepository.checkLaunchStatus();
        log("Status $status", name: "Auto Auth");
        if (status) {
          final user = await _authRepository.setUser();
          if (!isClosed && !emit.isDone) emit(AuthSuccess(user));
        } else {
          if (!isClosed && !emit.isDone) emit(const AuthSignUp());
        }
      }
      // //If they arent logged in on app launch, then this will auto sign them in once they have a valid session
      // _backendRepository.authEvents.onData((data) async {
      //   log("${data.type} ${data.payload}", name: "Auth Bloc");
      //   switch (data.type) {
      //     case AuthHubEventType.signedIn:
      //       log("Signed In");
      //       _authRepository.isSignedIn = true;
      //       final user = await _authRepository.setUser();
      //       if (!isClosed && !emit.isDone) emit(AuthSuccess(user: user));
      //       break;
      //     case AuthHubEventType.sessionExpired:
      //     case AuthHubEventType.signedOut:
      //     case AuthHubEventType.userDeleted:
      //       if (!isClosed && !emit.isDone) emit(const AuthSignUp());
      //   }
      // });
    } catch (e) {
      if (!isClosed && !emit.isDone)
        emit(AuthError(error: Exception("Failed to auto auth $e")));
    }
  }

  void _onToggle(AuthToggle event, Emitter<AuthState> emit) {
    if (state is AuthSignUp) {
      emit(const AuthLogIn());
    } else {
      emit(const AuthSignUp());
    }
  }

  void _onAttemptLogin(AuthAttemptLogIn event, Emitter<AuthState> emit) async {
    emit(const AuthLoad(message: "Logging in..."));

    try {
      final result = await _authRepository.completeLogin();
      if (result == "done") {
        final user = await _authRepository.setUser();
        if (!isClosed && !emit.isDone) emit(AuthSuccess(user));
      } else {
        if (!isClosed) emit(AuthCode(message: result));
      }
    } catch (e) {
      if (!isClosed) emit(AuthSignUp(message: e.toString()));
    }
  }

  void _onAttemptSignUp(
      AuthAttemptSignUp event, Emitter<AuthState> emit) async {
    emit(const AuthLoad(message: "Signing up..."));

    try {
      final result = await _authRepository.completeSignUp();
      if (result) {
        final user = await _authRepository.setUser();
        if (!isClosed && !emit.isDone) emit(AuthSuccess(user));
        return;
      } else {
        if (!isClosed) emit(const AuthCode());
        return;
      }
    } catch (e) {
      if (!isClosed) emit(AuthSignUp(message: e.toString()));
    }
  }

  FutureOr<void> _onGuest(AuthGuest event, Emitter<AuthState> emit) async {
    emit(const AuthLoad(message: "Logging in as guest..."));
    try {
      setData(AuthDataType.email, "gaitertech@gmail.com");
      setData(AuthDataType.password, "GaiterTech1!");
      add(const AuthAttemptLogIn());
    } catch (e) {
      if (!isClosed && !emit.isDone) emit(AuthSignUp(message: e.toString()));
    }
  }

  FutureOr<void> _onConfirm(AuthConfirm event, Emitter<AuthState> emit) async {
    emit(const AuthLoad(message: "Confirming code..."));
    try {
      final result = await _authRepository.confirmSignUpCode();
      final response = await _authRepository.completeLogin();
      if (result.isSignUpComplete && response == "done") {
        final user = await _authRepository.setUser();
        if (!isClosed && !emit.isDone) emit(AuthSuccess(user));
      } else {
        emit(AuthCode(message: response));
      }
    } on CodeMismatchException {
      emit(const AuthCode(message: "Invalid code"));
    } catch (e) {
      emit(AuthError(error: Exception("Failed to confirm code")));
    }
  }

  FutureOr<void> _onForgot(AuthForgotClicked event, Emitter<AuthState> emit) {
    emit(const AuthForgot());
  }

  FutureOr<void> _onConfirmedForgot(
      AuthConfirmedForgot event, Emitter<AuthState> emit) async {
    emit(const AuthLoad(message: "Checking email..."));
    final result = await _authRepository.resetPassword();
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
      if (!_authRepository.validateReset()) {
        emit(const AuthReset(message: "Passwords do not match"));
        return;
      }
      final result = await _authRepository.confirmResetPassword();
      if (result.isPasswordReset) {
        await _authRepository.completeLogin();
        final user = await _authRepository.setUser();
        if (!isClosed && !emit.isDone) emit(AuthSuccess(user));
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
      await _authRepository.signOut();
      if (!isClosed && !emit.isDone) {
        emit(const AuthSignUp(message: "Signed Out successfully"));
      }
    } catch (e) {
      if (!isClosed && !emit.isDone) {
        emit(AuthError(error: Exception("Failed to disconnect")));
      }
    }
  }

  void setData(AuthDataType type, String data) {
    if (type == AuthDataType.email) {
      _authRepository.setEmail(data);
    } else if (type == AuthDataType.password) {
      _authRepository.setPass(data);
    } else if (type == AuthDataType.confirmPassword) {
      _authRepository.setConfirmPass(data);
    } else if (type == AuthDataType.confirmCode) {
      _authRepository.setConfirmCode(data);
    }
  }
}
