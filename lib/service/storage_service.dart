import 'package:amplify_flutter/amplify_flutter.dart';

class StorageService {
  StorageService();
  void upload(HttpPayload data, String key) {
    Amplify.Storage.uploadData(data: data, key: key);
  }

  StorageDownloadDataOperation<StorageDownloadDataRequest,
      StorageDownloadDataResult<StorageItem>> download(String key) {
    return Amplify.Storage.downloadData(key: key);
  }

  Future<List<String>> listRawData() async {
    try {
      List<String> fileKeys = [];
      String? nextToken;
      bool hasNextPage;
      do {
        final result = await Amplify.Storage.list(
          path: 'raw/',
          options: StorageListOptions(
            pageSize: 1000,
            nextToken: nextToken,
          ),
        ).result;
        fileKeys.addAll(result.items.map((e) => e.key));
        nextToken = result.nextToken;
        hasNextPage = result.hasNextPage;
        print(nextToken);
      } while (hasNextPage);
      return fileKeys;
    } on StorageException catch (e) {
      safePrint('Error listing files: ${e.message}');
      rethrow;
    }
  }

  Future<void> moveFile({
    required String sourceKey,
    required String destinationKey,
  }) async {
    try {
      final result = await Amplify.Storage.move(
        source: StorageItemWithAccessLevel(
          storageItem: StorageItem(key: sourceKey),
          accessLevel: StorageAccessLevel.guest,
        ),
        destination: StorageItemWithAccessLevel(
          storageItem: StorageItem(key: destinationKey),
          accessLevel: StorageAccessLevel.guest,
        ),
      ).result;

      safePrint('Moved file to: ${result.movedItem.key}');
    } on StorageException catch (e) {
      safePrint('Something went wrong moving the file: ${e.message}');
      rethrow;
    }
  }
}
