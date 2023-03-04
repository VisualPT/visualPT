part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserNull extends UserState {
  final String? message;
  const UserNull({this.message});

  @override
  List<Object> get props => [message ?? ""];
}

class UserCurrent extends UserState {
  final User user;

  const UserCurrent({required this.user});
  @override
  List<Object> get props => [user];
}
