import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/service/user_service.dart';
import 'package:visualpt/models/ModelProvider.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  late User currentUser;
  UserBloc() : super(const UserNull()) {
    on<UserFetch>(_onFetch);
    on<UserClear>(_onClear);
  }

  FutureOr<void> _onFetch(UserEvent event, Emitter<UserState> emit) async {
    try {
      await userService.setUser().then((user) {
        currentUser = user;
        emit(UserCurrent(user: user));
      });
    } on Exception catch (e) {
      emit(UserNull(message: e.toString()));
    }
  }

  FutureOr<void> _onClear(UserClear event, Emitter<UserState> emit) {
    emit(const UserNull(message: "User Cleared"));
  }
}
