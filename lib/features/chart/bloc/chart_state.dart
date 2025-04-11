part of 'chart_bloc.dart';

@immutable
sealed class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object> get props => [];
}

final class ChartDataFetching extends ChartState {
  const ChartDataFetching();

  @override
  List<Object> get props => [];
}

final class ChartDataFetched extends ChartState {
  final GraphifyController controller;
  final Map<String, dynamic> chartOptions;
  final bool isLoading;
  const ChartDataFetched({
    required this.controller,
    required this.chartOptions,
    required this.isLoading,
  });

  @override
  List<Object> get props => [controller, chartOptions, isLoading];
}

final class ChartDataError extends ChartState {
  final String error;

  const ChartDataError({required this.error});

  @override
  List<Object> get props => [error];
}
