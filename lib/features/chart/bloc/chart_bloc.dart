import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphify/graphify.dart';

part 'chart_event.dart';
part 'chart_state.dart';

class ChartBloc<T> extends Bloc<ChartEvent, ChartState> {
  ChartBloc() : super(const ChartDataFetching()) {
    on<ChartDataFetchEvent>(_onChartDataFetch);
    on<ChartCreatedEvent>(_onChartCreated);
  }

  final controller = GraphifyController();

  FutureOr<void> _onChartDataFetch(event, emit) async {
    emit(const ChartDataFetching());
    try {
      final chartOptions = await event.fetchChartOptions();
      emit(ChartDataFetched(
          controller: controller, chartOptions: chartOptions, isLoading: true));
    } catch (e) {
      emit(ChartDataError(error: e.toString()));
    }
  }

  FutureOr<void> _onChartCreated(ChartCreatedEvent event, emit) {
    emit(ChartDataFetched(
        controller: controller,
        chartOptions: event.chartOptions,
        isLoading: false));
  }

  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }
}
