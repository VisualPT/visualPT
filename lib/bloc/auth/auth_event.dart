part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthAuto extends AuthEvent {
  const AuthAuto();
}

class AuthToggle extends AuthEvent {
  const AuthToggle();
}

class AuthAttemptLogIn extends AuthEvent {
  const AuthAttemptLogIn();
}

class AuthAttemptSignUp extends AuthEvent {
  const AuthAttemptSignUp();
}

class AuthConfirm extends AuthEvent {
  final AuthCodeDeliveryDetails? details;
  const AuthConfirm({this.details});
}

class AuthForgotClicked extends AuthEvent {
  const AuthForgotClicked();
}

class AuthConfirmedForgot extends AuthEvent {
  const AuthConfirmedForgot();
}

class AuthRestore extends AuthEvent {
  const AuthRestore();
}

class AuthDisconnect extends AuthEvent {
  const AuthDisconnect();
}
