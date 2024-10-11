import 'dart:async';
import 'dart:developer';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:visualpt/amplifyconfiguration.dart';
import 'package:visualpt/models/ModelProvider.dart';

class BackendService {
  ///Sets up the plugins for Amplify
  final StreamSubscription<DataStoreHubEvent> dataStoreSubscription =
      Amplify.Hub.listen((HubChannel.DataStore), (hubEvent) => hubEvent);
  final StreamSubscription<ApiHubEvent> apiSubscription =
      Amplify.Hub.listen((HubChannel.Api), (hubEvent) => hubEvent);
  final StreamSubscription<AuthHubEvent> authSubscription =
      Amplify.Hub.listen((HubChannel.Auth), (hubEvent) => hubEvent);

  //return log("${hubEvent.eventName} ${hubEvent.payload}", name: "Auth");
  //}

  ///SHOULD ONLY BE CALLED ONCE in entire codebase
  Future<void> configure() async {
    try {
      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyAPI(
            options: APIPluginOptions(modelProvider: ModelProvider.instance)),
        AmplifyDataStore(modelProvider: ModelProvider.instance),
        AmplifyStorageS3()
      ]);
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      throw ("Amplify is already configured, restart the application");
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> configProd() async => log(
      "Production (local storage persistant on app restart) or no user signed in",
      name: "Amplify Config Mode");

  Future<void> configDev() async {
    log("Development (local storage cleared and resynced upon app restarted)",
        name: "Amplify Config Mode");
    await Amplify.DataStore.clear();
    await Amplify.DataStore.start();
  }

  void dispose() {
    dataStoreSubscription.cancel();
    apiSubscription.cancel();
    authSubscription.cancel();
  }
}
