part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthSignUp extends AuthState {
  final String? message;
  AuthSignUp({this.message});
}

class AuthLogIn extends AuthState {
  final String? message;
  AuthLogIn({this.message});
}

class AuthValidate extends AuthState {
  final String? message;
  AuthValidate({this.message});
}

class AuthLoad extends AuthState {
  final String? message;
  AuthLoad({this.message});
}

class AuthError extends AuthState {
  final Exception? error;
  AuthError({this.error});
}
