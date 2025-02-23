import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visualpt/models/ModelProvider.dart';

Future<void> configure(String config) async {
  await _configureEnv();
  await _configureAmplify(config);
}

Future<void> _configureEnv() async {
  await dotenv.load(fileName: ".env");
}

Future<void> _configureAmplify(String amplifyconfig) async {
  try {
    await Amplify.addPlugins([
      AmplifyAuthCognito(),
      AmplifyAPI(
          options: APIPluginOptions(modelProvider: ModelProvider.instance)),
      // TODO:AmplifyStorageS3()
    ]);
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException {
    throw ("Amplify is already configured, restart the application");
  } catch (e) {
    throw e.toString();
  }
}

Future<void> requestPermissions(void Function() onError) async {
  if (await AppTrackingTransparency.trackingAuthorizationStatus ==
      TrackingStatus.notDetermined) {
    await Future.delayed(const Duration(milliseconds: 200));
    await AppTrackingTransparency.requestTrackingAuthorization();

    if (await Permission.camera.request() != PermissionStatus.granted) {
      onError();
    }
  }
}
