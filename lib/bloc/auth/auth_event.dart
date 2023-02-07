part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthToggle extends AuthEvent {}

class AuthAttempt extends AuthEvent {
  final AuthData authData;
  AuthAttempt({required this.authData});
}
