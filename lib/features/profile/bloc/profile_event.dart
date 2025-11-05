part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

final class ProfileLoad extends ProfileEvent {
  const ProfileLoad();

  @override
  List<Object?> get props => [];
}

final class ProfileCreate extends ProfileEvent {
  final Profile profile;

  const ProfileCreate(this.profile);

  @override
  List<Object?> get props => [profile];
}
