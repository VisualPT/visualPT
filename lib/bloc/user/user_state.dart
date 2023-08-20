part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  final User? user;
  const UserState({required this.user});

  @override
  List<Object> get props => [user ?? ""];
}

class UserNull extends UserState {
  final String? message;
  const UserNull({this.message}) : super(user: null);

  @override
  List<Object> get props => [message ?? ""];
}

class UserCurrent extends UserState {
  const UserCurrent({required super.user});
  @override
  List<Object> get props => [];
}
