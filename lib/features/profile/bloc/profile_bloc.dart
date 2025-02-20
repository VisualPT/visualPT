import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/features/profile/service/profiles_service.dart';
import 'package:visualpt/models/Profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileLoading()) {
    on<ProfileLoad>(_onLoad);
    on<ProfileCreate>(_onCreate);
  }

  FutureOr<void> _onLoad(event, emit) async {
    emit(const ProfileLoading());
    try {
      final profiles = await ProfilesService.queryListProfiles();
      emit(ProfileLoaded(profiles));
    } catch (e) {
      emit(ProfileError(Exception(e)));
    }
  }

  FutureOr<void> _onCreate(event, emit) async {
    emit(const ProfileLoading());
    try {
      await ProfilesService.create(event.profile);
      add(const ProfileLoad());
    } catch (e) {
      emit(ProfileError(Exception(e)));
    }
  }
}
