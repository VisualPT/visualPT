import 'dart:async';
import 'dart:developer';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:visualpt/amplifyconfiguration.dart';
import 'package:visualpt/models/ModelProvider.dart';

class BackendService {
  ///Sets up the plugins for Amplify
  ///SHOULD ONLY BE CALLED ONCE in entire codebase
  void initialConfig(
      {required void Function() onSuccess,
      required void Function(String) onFail}) async {
    try {
      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyAPI(),
        AmplifyDataStore(modelProvider: ModelProvider.instance),
      ]);
      await Amplify.configure(amplifyconfig).then((_) {
        kDebugMode ? verboseBackend() : null;
        //kDebugMode ? configDev() : configProd();
        onSuccess();
      });
    } on AmplifyAlreadyConfiguredException {
      onFail("Amplify is already configured, restart the application");
    } on Exception catch (e) {
      log(e.toString());
      onFail(e.toString());
    }
  }

  Future<void> configProd() async => log(
      "Production (local storage persistant on app restart) or no user signed in",
      name: "Amplify Config Mode");

  Future<void> configDev() async {
    log("Development (local storage cleared and resynced upon app restarted)",
        name: "Amplify Config Mode");
    await Amplify.DataStore.clear().then((_) => Amplify.DataStore.start());
  }

  void verboseBackend() {
    Amplify.Hub.listen((HubChannel.DataStore), (hubEvent) {
      log("${hubEvent.eventName} ${hubEvent.payload}",
          name: "Amplify DataStore");
    });
    Amplify.Hub.listen((HubChannel.Api), (hubEvent) {
      log("${hubEvent.eventName} ${hubEvent.payload}", name: "Amplify Api");
    });
    Amplify.Hub.listen((HubChannel.Api), (hubEvent) {
      log("${hubEvent.eventName} ${hubEvent.payload}", name: "Amplify Api");
    });
  }

  //Monitors network status of application
  //Possible future bug when backend is actually used, instead of emitting [BackendConnected] when the device is reconnected to a network, we need to check if the backend is configured and if it isnt, configure it.
  StreamSubscription<ConnectivityResult> observeConnectivity(
          {required void Function() onConnectionNone}) =>
      Connectivity().onConnectivityChanged.listen((event) {
        log(event.toString());
        event == ConnectivityResult.none ? onConnectionNone() : null;
      });
}
