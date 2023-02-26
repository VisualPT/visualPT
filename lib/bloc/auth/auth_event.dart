part of 'auth_bloc.dart';

enum AuthMethod { signUp, logIn }

@immutable
abstract class AuthEvent {}

class AuthAuto extends AuthEvent {}

class AuthToggle extends AuthEvent {
  AuthToggle();
}

class AuthAttempt extends AuthEvent {
  final AuthData authData;
  AuthAttempt({required this.authData});
}
