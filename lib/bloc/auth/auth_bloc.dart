import 'dart:async';
import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/components/_components.dart';

part 'auth_event.dart';
part 'auth_state.dart';

enum AuthDataType { email, password, confirmPassword }

//TODO possibly a security risk, address this before production
class AuthData {
  late String email = "";
  late String password = "";
  late String confirmPassword = "";

  void setEmail(String value) => email = value;
  void setPass(String value) => password = value;
  void setConfirmPass(String value) => confirmPassword = value;

  bool isLoginValid() =>
      email.contains(RegExp(
          r'''(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])''')) &&
      password.contains(RegExp(
          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$'));
  bool isSignupValid() => isLoginValid() && password == confirmPassword;
  void debugPrint() =>
      log("email:$email\npass:$password\nconfirm:$confirmPassword\n");
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthData authData = AuthData();
  bool method = true; //True = Login/False = Signup
  late GlobalKey<ShakerState> shake; //For invalid response purposes

  AuthBloc() : super(AuthLoading()) {
    on<AuthAuto>(_authAuto);
    on<AuthToggle>(_authToggled);
    on<AuthAttempt>(_authAttempted);
  }

  FutureOr<void> _authAuto(AuthAuto event, Emitter<AuthState> emit) {
    //TODO Get all the users data and put it in a singleton
    Amplify.Auth.fetchUserAttributes();
    emit(AuthSuccess());
  }

  void _authToggled(AuthToggle event, Emitter<AuthState> emit) {
    state is AuthSignUp ? emit(AuthLogIn()) : emit(AuthSignUp());
    method = !method;
  }

  void _authAttempted(AuthAttempt event, Emitter<AuthState> emit) async {
    if (state is AuthLogIn && event.authData.isLoginValid()) {
      log("LogIn Data Validated");
      //TODO set up the user account in the cloud
      emit(AuthSuccess());
    } else if (state is AuthSignUp && event.authData.isSignupValid()) {
      log("SignUp Data Validated");
      //TODO set up the user account in the cloud
      emit(AuthSuccess());
    } else {
      getShake();
      // final tempState = state;
      // emit(AuthError("Something went wrong, please try again"));
      // await Future.delayed(
      //     const Duration(milliseconds: 100), () => emit(tempState));
    }
  }

  void fetchAuth() {
    Amplify.Auth.fetchAuthSession().asStream().listen((authSession) =>
        authSession.isSignedIn ? add(AuthAuto()) : add(AuthToggle()));
  }

  void storeAuthData(AuthDataType type, String data) {
    if (type == AuthDataType.email) {
      authData.setEmail(data);
    } else if (type == AuthDataType.password) {
      authData.setPass(data);
    } else if (type == AuthDataType.confirmPassword) {
      authData.setConfirmPass(data);
    }
  }

  setShake(GlobalKey<ShakerState> shakeKey) {
    shake = shakeKey;
  }

  getShake() {
    shake.currentState?.shake();
  }

  // void clearInput(TextEditingController controller) {
  //   print("Attempting to Clear");
  //   if (state is AuthError) {
  //     controller.clear();
  //   }
  // }
}
