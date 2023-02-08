import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

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
  bool isLoginReady() => email.isNotEmpty && password.isNotEmpty;
//TODO REGEX FOR EMAIL VALIDATION AND PASSWORD STRENGTH
  bool isSignupReady() =>
      email.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      password == confirmPassword;
  void debugPrint() =>
      print("email:$email\npass:$password\nconfirm:$confirmPassword\n");
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthData authData = AuthData();
  bool method = true; //True = Login/False = Signup
  AuthBloc() : super(AuthLogin()) {
    on<AuthToggle>(_authToggled);
    on<AuthAttempt>(_authAttempted);
  }
  void _authToggled(AuthToggle event, Emitter<AuthState> emit) {
    state is AuthSignUp ? emit(AuthLogin()) : emit(AuthSignUp());
    method = !method;
  }

  void _authAttempted(AuthAttempt event, Emitter<AuthState> emit) async {
    if (state is AuthLogin && event.authData.isLoginReady()) {
      //TODO set up the user account in the cloud
      emit(AuthSuccess());
    } else if (state is AuthSignUp && event.authData.isSignupReady()) {
      //TODO set up the user account in the cloud
      emit(AuthSuccess());
    } else {
      final tempState = state;
      emit(AuthError("Something went wrong, please try again"));
      await Future.delayed(const Duration(seconds: 1), () => emit(tempState));
    }
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

  void clearInput(TextEditingController controller) {
    print("Attempting to Clear");
    if (state is AuthError) {
      controller.clear();
    }
  }
}
