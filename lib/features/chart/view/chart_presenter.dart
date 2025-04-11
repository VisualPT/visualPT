import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/chart/bloc/chart_bloc.dart';

class ChartPresenter extends StatelessWidget {
  final ChartDataFetchEvent onCreate;
  final Widget Function(BuildContext context, ChartDataFetching state)
      onFetching;
  final Widget Function(BuildContext context, ChartDataFetched state) onFetched;
  final Widget Function(BuildContext context, ChartState state, Exception e)
      onError;

  const ChartPresenter(
      {super.key,
      required this.onCreate,
      required this.onFetching,
      required this.onFetched,
      required this.onError});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChartBloc()..add(onCreate),
      child: BlocBuilder<ChartBloc, ChartState>(
        builder: (context, state) {
          try {
            if (state is ChartDataFetching) {
              return onFetching(context, state);
            } else if (state is ChartDataFetched) {
              return onFetched(context, state);
            } else if (state is ChartDataError) {
              return onError(context, state, Exception(state.error));
            } else {
              return onError(context, state, Exception("Unknown state"));
            }
          } catch (e) {
            return onError(context, state, Exception(e.toString()));
          }
        },
      ),
    );
  }
}
