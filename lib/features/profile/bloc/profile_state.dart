part of 'profile_bloc.dart';

@immutable
sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();

  @override
  List<Object?> get props => [];
}

final class ProfileLoaded extends ProfileState {
  final List<Profile?> profiles;

  const ProfileLoaded(this.profiles);

  @override
  List<Object?> get props => [profiles];
}

final class ProfileError extends ProfileState {
  final Exception error;

  const ProfileError(this.error);

  @override
  List<Object?> get props => [error];
}
