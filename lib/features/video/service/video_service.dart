import 'dart:convert';

import 'package:visualpt/features/backend/service/storage_service.dart';
import 'package:visualpt/models/Assessment.dart';

class VideoService {
  static Future<List<String>> getVideosInBase64(Assessment assessment) async {
    final storage = StorageService();
// Collect all the futures for downloading and encoding the videos
    // Collect all the futures for downloading and encoding the videos
    final videoFutures = assessment.Conditions?.expand((c) =>
            c.trials?.map<Future<String>>((t) async {
              final path =
                  "${assessment.type.name}/video/${t.start_time.getDateTimeInUtc().millisecondsSinceEpoch.toString()}.mp4";
              final download = storage.download(path: path);
              final data = await download.result;
              return base64Encode(data.bytes);
            }) ??
            const Iterable<Future<String>>.empty()) ??
        const Iterable<Future<String>>.empty();

    return await Future.wait(videoFutures);
  }
}
