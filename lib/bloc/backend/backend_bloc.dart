import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/service/backend_service.dart';

part 'backend_event.dart';
part 'backend_state.dart';

class BackendBloc extends Bloc<BackendEvent, BackendState> {
  final BackendService backendService = BackendService();

  BackendBloc() : super(const BackendOffline("No connection established")) {
    on<BackendAttemptSync>(_onAttempt);
    on<BackendFailSync>(_onFail);

    backendService.observeConnectivity(
        onConnectionNone: () =>
            add(const BackendFailSync("Lost Connectivity")));
  }

  FutureOr<void> _onAttempt(
      BackendAttemptSync event, Emitter<BackendState> emit) async {
    try {
      emit(const BackendLoading());
      log("Connecting to Backend", name: "Backend Bloc");
      await backendService.initialConfig(
          onFail: (message) => emit(BackendOffline(message)));
      emit(const BackendOnline());
    } catch (e) {
      emit(BackendOffline(e.toString()));
    }
  }

  FutureOr<void> _onFail(BackendFailSync event, Emitter<BackendState> emit) {
    emit(BackendOffline(event.message));
  }

  //TOOD: put this somewhere better
  void backendLoading() {
    StreamSubscription<Duration> timer = const Ticker().tick().listen((_) {});
    timer.onData((data) {
      if (state is BackendOnline) {
        log("Ending timeout timer");
        timer.cancel();
      }
      if (data.inSeconds == 5) {
        add(const BackendFailSync("Connection Timed Out"));
        timer.cancel();
      }
    });
  }

  //Delays queries until DataStore is completely synced
  // void syncListener() {
  //   Amplify.Hub.listen(([HubChannel.DataStore]), (hubEvent) {
  //     log("${hubEvent.eventName} ${hubEvent.payload}");
  //     if (hubEvent.eventName == 'ready') {
  //       emit(const BackendOnline());
  //     }
  //   });
  // }
}
