import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/core/_core.dart';

import 'package:visualpt/models/Profile.dart';
import 'package:visualpt/features/profile/_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileLoading()) {
    on<ProfileLoad>(_onLoad);
    on<ProfileCreate>(_onCreate);
  }

  FutureOr<void> _onLoad(ProfileLoad event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    try {
      final profiles = await ProfileService.list();
      final definedProfileList =
          profiles.where((profile) => profile != null).cast<Profile>().toList();
      emit(ProfileLoaded(definedProfileList));
    } catch (e) {
      log(e.toString());
      emit(ProfileError(Exception(e)));
    }
  }

  FutureOr<void> _onCreate(
      ProfileCreate event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    try {
      await ApiService.create(event.profile);
      add(const ProfileLoad());
    } catch (e) {
      emit(ProfileError(Exception(e)));
    }
  }
}
