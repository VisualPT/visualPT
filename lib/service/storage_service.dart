import 'package:amplify_flutter/amplify_flutter.dart';

class StorageService {
  StorageService();
  void upload(HttpPayload data, String key) {
    Amplify.Storage.uploadData(data: data, key: key);
  }

  StorageListOperation<StorageListRequest, StorageListResult<StorageItem>>
      list() {
    return Amplify.Storage.list();
  }
}
