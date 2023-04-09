part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthAuto extends AuthEvent {
  final Function onSuccess;
  AuthAuto({required this.onSuccess});
}

class AuthToggle extends AuthEvent {
  AuthToggle();
}

class AuthAttempt extends AuthEvent {
  final Function onSuccess;
  AuthAttempt({required this.onSuccess});
}

class AuthConfirm extends AuthEvent {
  final Function onSuccess;
  AuthConfirm({required this.onSuccess});
}
