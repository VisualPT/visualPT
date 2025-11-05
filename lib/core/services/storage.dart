import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class StorageService {
  StorageService();
  void upload(S3DataPayload data, String path) {
    try {
      Amplify.Storage.uploadData(
        data: data,
        path: StoragePath.fromString(path),
      );
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  StorageDownloadDataOperation<StorageDownloadDataRequest,
      StorageDownloadDataResult<StorageItem>> download({
    required String path,
  }) {
    return Amplify.Storage.downloadData(
      path: StoragePath.fromString(path),
    );
  }

  StorageGetUrlOperation<StorageGetUrlRequest, StorageGetUrlResult> getUrl(
      {required String path}) {
    return Amplify.Storage.getUrl(path: StoragePath.fromString(path));
  }

  Future<List<String>> listRawData(String path) async {
    try {
      List<String> fileKeys = [];
      String? nextToken;
      bool hasNextPage;
      do {
        final result = await Amplify.Storage.list(
          path: StoragePath.fromString('$path/raw/'),
          options: StorageListOptions(
            pageSize: 1000,
            nextToken: nextToken,
            pluginOptions: const S3ListPluginOptions(
              excludeSubPaths: true,
            ),
          ),
        ).result;
        fileKeys.addAll(result.items.map((e) => e.path));
        nextToken = result.nextToken;
        hasNextPage = result.hasNextPage;
      } while (hasNextPage);
      return fileKeys;
    } on StorageException catch (e) {
      safePrint('Error listing files: ${e.message}');
      rethrow;
    }
  }

  Future<void> move({
    required String path,
    required String sourceKey,
    required String destinationKey,
  }) async {
    try {
      await Amplify.Storage.copy(
        source: StoragePath.fromString('$path/$sourceKey'),
        destination: StoragePath.fromString('$path/$destinationKey'),
      ).result;
    } catch (e) {
      safePrint('Error moving file: $e with key $sourceKey');
      rethrow;
    }
  }

  void remove(String path) {
    Amplify.Storage.remove(path: StoragePath.fromString(path));
  }
}
