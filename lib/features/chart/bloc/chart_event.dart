part of 'chart_bloc.dart';

@immutable
sealed class ChartEvent extends Equatable {
  const ChartEvent();

  @override
  List<Object> get props => [];
}

class ChartDataFetchEvent<T> extends ChartEvent {
  final Future<Map<String, dynamic>> Function() fetchChartOptions;

  const ChartDataFetchEvent({required this.fetchChartOptions});

  @override
  List<Object> get props => [fetchChartOptions];
}

class ChartCreatedEvent extends ChartEvent {
  final Map<String, dynamic> chartOptions;

  const ChartCreatedEvent({required this.chartOptions});

  @override
  List<Object> get props => [chartOptions];
}
