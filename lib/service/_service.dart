import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';

abstract class AppService {
  void getData(Model model) {}

  void saveData(Model model) {
    log("Saving ${model.toJson()} to DataStore");
    //TODO save this data to the DataStore when production ready
    //Amplify.DataStore.save(model);
  }
}
