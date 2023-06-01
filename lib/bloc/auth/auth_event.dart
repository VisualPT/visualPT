part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthAuto extends AuthEvent {
  final void Function() onSuccess;
  AuthAuto({required this.onSuccess});
}

class AuthToggle extends AuthEvent {
  AuthToggle();
}

class AuthAttempt extends AuthEvent {
  final void Function() onSuccess;
  AuthAttempt({required this.onSuccess});
}

class AuthConfirm extends AuthEvent {
  final AuthCodeDeliveryDetails? details;
  final void Function() onSuccess;
  AuthConfirm({this.details, required this.onSuccess});
}
