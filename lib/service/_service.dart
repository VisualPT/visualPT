import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';

export 'auth_service.dart';
export 'backend_service.dart';
export 'camera_service.dart';
export 'email_service.dart';
export 'patient_service.dart';
export 'user_service.dart';

abstract class AppService {
  void getData(Model model) {}

  void saveData(Model model) {
    log("Saving ${model.toJson()} to DataStore");
    Amplify.DataStore.save(model);
  }
}
