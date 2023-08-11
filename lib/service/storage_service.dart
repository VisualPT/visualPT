import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class StorageService {
  StorageService();
  void upload(HttpPayload data, String key) {
    Amplify.Storage.uploadData(data: data, key: key);
  }

  StorageDownloadDataOperation<StorageDownloadDataRequest,
      StorageDownloadDataResult<StorageItem>> download(String key) {
    return Amplify.Storage.downloadData(key: key);
  }

  StorageGetUrlOperation<StorageGetUrlRequest, StorageGetUrlResult> getUrl(
      String key) {
    return Amplify.Storage.getUrl(key: key);
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

  void remove(String key) {
    Amplify.Storage.remove(key: key);
  }
}
