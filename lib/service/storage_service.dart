import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class StorageService {
  StorageService();
  void upload(HttpPayload data, String key, StorageAccessLevel accessLevel) {
    Amplify.Storage.uploadData(
        data: data,
        key: key,
        options: StorageUploadDataOptions(accessLevel: accessLevel));
  }

  StorageDownloadDataOperation<StorageDownloadDataRequest,
          StorageDownloadDataResult<StorageItem>>
      download(String key, StorageAccessLevel accessLevel) {
    return Amplify.Storage.downloadData(
        key: key,
        options: StorageDownloadDataOptions(accessLevel: accessLevel));
  }

  StorageGetUrlOperation<StorageGetUrlRequest, StorageGetUrlResult> getUrl(
      String key, StorageAccessLevel accessLevel) {
    return Amplify.Storage.getUrl(
        key: key, options: StorageGetUrlOptions(accessLevel: accessLevel));
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
            accessLevel: StorageAccessLevel.private,
            pageSize: 1000,
            nextToken: nextToken,
            pluginOptions: const S3ListPluginOptions(
              excludeSubPaths: true,
            ),
          ),
        ).result;
        fileKeys.addAll(result.items.map((e) => e.key));
        nextToken = result.nextToken;
        hasNextPage = result.hasNextPage;
      } while (hasNextPage);
      return fileKeys;
    } on StorageException catch (e) {
      safePrint('Error listing files: ${e.message}');
      rethrow;
    }
  }

  void move(
      {required String sourceKey,
      required String destinationKey,
      StorageAccessLevel sourceAccessLevel = StorageAccessLevel.private,
      StorageAccessLevel destinationAccessLevel = StorageAccessLevel.private}) {
    Amplify.Storage.move(
        source: StorageItemWithAccessLevel(
            storageItem: StorageItem(key: sourceKey),
            accessLevel: sourceAccessLevel),
        destination: StorageItemWithAccessLevel(
            storageItem: StorageItem(key: destinationKey),
            accessLevel: destinationAccessLevel));
  }

  void remove(String key, StorageAccessLevel accessLevel) {
    Amplify.Storage.remove(
        key: key, options: StorageRemoveOptions(accessLevel: accessLevel));
  }
}
