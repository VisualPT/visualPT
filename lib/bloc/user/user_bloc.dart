import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/bloc/user/user_data.dart';
import 'package:visualpt/models/ModelProvider.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserNull()) {
    on<UserEvent>(_onFetch);
  }

  FutureOr<void> _onFetch(UserEvent event, Emitter<UserState> emit) async {
    try {
      await UserData().initUser().then((user) => emit(UserCurrent(user: user)));
    } on Exception catch (e) {
      emit(UserNull(message: e.toString()));
    }
  }
}
