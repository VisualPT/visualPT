import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';

abstract class AppService {
  void getData(Model model) {}

  void saveData(Model model) {
    log("Saving ${model.toJson()} to DataStore |||| t: ${DateTime.now().microsecond}");
    Amplify.DataStore.save(model);
  }
}
