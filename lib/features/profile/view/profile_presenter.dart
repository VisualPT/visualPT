import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/profile/_profile.dart';

class ProfilePresenter extends StatelessWidget {
  final Widget Function(BuildContext context, ProfileLoading state) onLoading;
  final Widget Function(BuildContext context, ProfileLoaded state) onLoaded;
  final Widget Function(BuildContext context, ProfileState state, Exception? e)
      onError;
  const ProfilePresenter({
    super.key,
    required this.onLoading,
    required this.onLoaded,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(const ProfileLoad()),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          try {
            return switch (state) {
              ProfileLoading() => onLoading(context, state),
              ProfileLoaded() => onLoaded(context, state),
              ProfileError() => onError(context, state, null),
            };
          } catch (e) {
            return onError(context, state, e as Exception);
          }
        },
      ),
    );
  }
}
