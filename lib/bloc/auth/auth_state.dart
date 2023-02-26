part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthSignUp extends AuthState {}

class AuthLogIn extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
