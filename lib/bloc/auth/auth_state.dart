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
