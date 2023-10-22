part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthSignUp extends AuthState {
  final String? message;
  const AuthSignUp({this.message});

  @override
  List<Object?> get props => [];
}

class AuthLogIn extends AuthState {
  final String? message;
  const AuthLogIn({this.message});

  @override
  List<Object?> get props => [];
}

class AuthForgot extends AuthState {
  final String? message;
  const AuthForgot({this.message});

  @override
  List<Object?> get props => [];
}

class AuthCode extends AuthState {
  final String? message;
  const AuthCode({this.message});

  @override
  List<Object?> get props => [];
}

class AuthReset extends AuthState {
  final String? message;
  const AuthReset({this.message});

  @override
  List<Object?> get props => [];
}

class AuthLoad extends AuthState {
  final String? message;
  const AuthLoad({this.message});

  @override
  List<Object?> get props => [];
}

class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthError extends AuthState {
  final Exception? error;
  const AuthError({this.error});

  @override
  List<Object?> get props => [];
}
