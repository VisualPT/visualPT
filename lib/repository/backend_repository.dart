import 'dart:async';
import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:visualpt/service/backend_service.dart';

class BackendRepository {
  BackendRepository();
  final BackendService _backendService = BackendService();

  //Possible future bug when backend is actually used, instead of emitting [BackendConnected] when the device is reconnected to a network, we need to check if the backend is configured and if it isnt, configure it.
  Stream<ConnectivityResult> get connectivityEvents =>
      Connectivity().onConnectivityChanged.asBroadcastStream();
  StreamSubscription<DataStoreHubEvent> get datastoreEvents =>
      _backendService.dataStoreSubscription;
  StreamSubscription<ApiHubEvent> get apiEvents =>
      _backendService.apiSubscription;
  StreamSubscription<AuthHubEvent> get authEvents =>
      _backendService.authSubscription;

  Future<void> init() async {
    await _backendService.configure();
    kDebugMode ? verboseBackend() : null;
  }

  void verboseBackend() {
    log("true", name: "Verbose backend logging enabled");
    connectivityEvents
        .listen((event) => log(event.toString(), name: "Connectivity"));
    _backendService.dataStoreSubscription
      ..onData((event) =>
          log("${event.eventName} ${event.payload}", name: "DataStore"))
      ..onError((e) => log(e.toString(), name: "DataStore Error"));
    _backendService.apiSubscription
      ..onData(
          (event) => log("${event.eventName} ${event.payload}", name: "Api"))
      ..onError((e) => log(e.toString(), name: "Api Error"));
    ;
    _backendService.authSubscription
      ..onData(
          (event) => log("${event.eventName} ${event.payload}", name: "Auth"))
      ..onError((e) => log(e.toString(), name: "Auth Error"));
    ;
  }

  void dispose() {
    _backendService.dispose();
  }
}
