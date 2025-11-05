import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphify/graphify.dart';
import 'package:visualpt/features/chart/bloc/chart_bloc.dart';
import 'package:visualpt/features/chart/view/chart_presenter.dart';

class ChartView extends StatelessWidget {
  const ChartView({super.key, required this.onCreate});

  final ChartDataFetchEvent onCreate;

  @override
  Widget build(BuildContext context) {
    return ChartPresenter(
      onCreate: onCreate,
      onFetching: (context, state) {
        return const SizedBox(
          width: double.infinity,
          height: 300, // Set a fixed height for the loading indicator
          child: Center(child: CircularProgressIndicator()),
        );
      },
      onFetched: (context, state) {
        return SizedBox(
          width: double.infinity, // Constrain width to avoid infinite size
          height:
              300, // Set a fixed height or use MediaQuery to make it responsive
          child: Stack(
            children: [
              GraphifyView(
                controller: state.controller,
                initialOptions: state.chartOptions,
                onConsoleMessage: (message) {
                  print(message);
                },
                onCreated: () {
                  BlocProvider.of<ChartBloc>(context)
                      .add(ChartCreatedEvent(chartOptions: state.chartOptions));
                },
              ),
              if (state.isLoading) // Check if loading
                const Center(
                    child:
                        CircularProgressIndicator()), // Show loading indicator
            ],
          ),
        );
      },
      onError: (context, state, error) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'An error occurred: ${error.toString()}',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Trigger a reload or refresh action
                BlocProvider.of<ChartBloc>(context).add(onCreate);
              },
              child: const Text('Reload'),
            ),
          ],
        );
      },
    );
  }
}
