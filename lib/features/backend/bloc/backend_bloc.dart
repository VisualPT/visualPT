import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/features/backend/service/backend_repository.dart';
import 'package:visualpt/features/timer/bloc/timer_bloc.dart';

part 'backend_event.dart';
part 'backend_state.dart';

class BackendBloc extends Bloc<BackendEvent, BackendState> {
  final BackendRepository backendRepository;
  BackendBloc(this.backendRepository)
      : super(const BackendOffline("No connection established")) {
    on<BackendAttemptSync>(_onAttempt);
    on<BackendFailSync>(_onFail);

    backendRepository.connectivityEvents.listen((data) {
      if (data == ConnectivityResult.none) {
        add(const BackendFailSync("No Connection"));
      }
    });
  }
  FutureOr<void> _onAttempt(
      BackendAttemptSync event, Emitter<BackendState> emit) async {
    try {
      if (!isClosed) emit(const BackendLoading());
      log("Connecting to Backend", name: "Backend Bloc");
      await backendRepository.init();
      if (!isClosed) emit(const BackendOnline());
    } catch (e) {
      if (!isClosed) emit(BackendOffline(e.toString()));
    }
  }

  FutureOr<void> _onFail(BackendFailSync event, Emitter<BackendState> emit) {
    if (!isClosed) emit(BackendOffline(event.message));
  }

  //TOOD: put this somewhere better
  void backendLoading() {
    StreamSubscription<Duration> timer =
        const Ticker(duration: Duration(seconds: 30)).tick().listen((_) {});
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
