import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:visualpt/amplifyconfiguration.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';

part 'backend_event.dart';
part 'backend_state.dart';

class BackendBloc extends Bloc<BackendEvent, BackendState> {
  final AmplifyDataStore _dataStorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);
  final AmplifyAPI _apiPlugin = AmplifyAPI();
  final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();
  final AmplifyStorageS3 _storagePlugin = AmplifyStorageS3();

  BackendBloc() : super(const BackendOffline("No connection established")) {
    monitorConnectivity();
    on<BackendAttemptSync>(_onAttempt);
    on<BackendSuccessSync>(_onSuccess);
    on<BackendFailSync>(_onFail);
  }

  FutureOr<void> _onAttempt(
      BackendAttemptSync event, Emitter<BackendState> emit) async {
    log("Attempting Connection");

    emit(const BackendLoading());
    try {
      await Amplify.addPlugins(
          [_dataStorePlugin, _apiPlugin, _authPlugin, _storagePlugin]);
      await Amplify.configure(amplifyconfig).then((value) {
        kDebugMode ? verboseBackend() : null;
        //kDebugMode ? configDev() : configProd();

        add(const BackendSuccessSync());
      });
    } on AmplifyAlreadyConfiguredException {
      add(const BackendFailSync(
          'Reset VisualPT to refresh the back end services.'));
    } on Exception catch (e) {
      log(e.toString());
      add(BackendFailSync(e.toString()));
    }
  }

  FutureOr<void> _onSuccess(
      BackendSuccessSync event, Emitter<BackendState> emit) async {
    emit(BackendOnline());
    log("Successful Connection");
  }

  FutureOr<void> _onFail(BackendFailSync event, Emitter<BackendState> emit) {
    log("Failed Connection");
    emit(BackendOffline(event.message));
  }

  //Monitors network status of application
  //Possible future bug when backend is actually used, instead of emitting [BackendConnected] when the device is reconnected to a network, we need to check if the backend is configured and if it isnt, configure it.
  void monitorConnectivity() =>
      Connectivity().onConnectivityChanged.listen((event) {
        log(event.toString());
        event == ConnectivityResult.none
            ? add(const BackendFailSync("Lost Connectivity"))
            : null;
      });

  Future<void> configProd() async => log(
      "Production (local storage persistant on app restart) or no user signed in",
      name: "Amplify Config Mode");

  Future<void> configDev() async {
    log("Development (local storage cleared and resynced upon app restarted)",
        name: "Amplify Config Mode");
    await Amplify.DataStore.clear().then((_) => Amplify.DataStore.start());
  }

  void verboseBackend() {
    Amplify.Hub.listen(([HubChannel.DataStore, HubChannel.Auth]), (hubEvent) {
      log("${hubEvent.eventName} ${hubEvent.payload}", name: "Amplify");
    });
  }

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
