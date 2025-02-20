import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/assessment/types.dart';
import 'package:visualpt/features/capture/bloc/capture_bloc.dart';
import 'package:visualpt/features/capture/service/capture_repository.dart';

class CapturePresenter extends StatelessWidget {
  final bool storeData;
  final TrialMeta meta;
  final int durationSeconds;
  final Widget Function(BuildContext context, CaptureDelegated state)
      onDelegated;
  final Widget Function(BuildContext context, CaptureEnded state) onEnded;
  final Widget Function(BuildContext context, CaptureState state, Exception e)
      onError;
  const CapturePresenter(
    this.storeData,
    this.meta,
    this.durationSeconds, {
    super.key,
    required this.onDelegated,
    required this.onEnded,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => CaptureRepository(storeData)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CaptureBloc(
              RepositoryProvider.of<CaptureRepository>(context),
              meta,
              Duration(seconds: durationSeconds),
            ),
          ),
        ],
        child: BlocBuilder<CaptureBloc, CaptureState>(
          builder: (context, state) {
            try {
              return switch (state) {
                CaptureDelegated() => onDelegated(context, state),
                CaptureEnded() => onEnded(context, state),
                _ => throw Exception("Undefined State $state"),
              };
            } catch (e) {
              return onError(context, state, e as Exception);
            }
          },
        ),
      ),
    );
  }
}
