import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/service/user_service.dart';
import 'package:visualpt/models/ModelProvider.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserService userService = UserService();
  UserBloc() : super(const UserNull()) {
    on<UserFetch>(_onFetch);
    on<UserClear>(_onClear);
  }

  FutureOr<void> _onFetch(UserEvent event, Emitter<UserState> emit) async {
    try {
      final user = await userService.setUser();
      emit(UserCurrent(user: user));
    } on Exception catch (e) {
      emit(UserNull(message: e.toString()));
    }
    log("Done");
  }

  FutureOr<void> _onClear(UserClear event, Emitter<UserState> emit) {
    emit(const UserNull(message: "User Cleared"));
  }
}
