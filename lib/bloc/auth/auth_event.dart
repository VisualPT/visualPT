part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthAuto extends AuthEvent {
  AuthAuto();
}

class AuthToggle extends AuthEvent {
  AuthToggle();
}

class AuthAttempt extends AuthEvent {
  AuthAttempt();
}

class AuthConfirm extends AuthEvent {
  final AuthCodeDeliveryDetails? details;
  AuthConfirm({this.details});
}

class AuthForgot extends AuthEvent {
  AuthForgot();
}

class AuthConfirmedForgot extends AuthEvent {
  AuthConfirmedForgot();
}

class AuthRestore extends AuthEvent {
  AuthRestore();
}

class AuthDisconnect extends AuthEvent {
  AuthDisconnect();
}
