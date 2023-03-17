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
  AuthConfirm();
}
