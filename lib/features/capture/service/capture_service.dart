import 'dart:convert';

import 'package:visualpt/core/services/storage.dart';
import 'package:visualpt/models/Assessment.dart';

class VideoService {
  static Future<List<String>> getVideosInBase64(Assessment assessment) async {
    final storage = StorageService();
// Collect all the futures for downloading and encoding the videos
    // Collect all the futures for downloading and encoding the videos
    final videoFutures = assessment.stages?.expand<Future<String>>((c) =>
            c.trials?.map<Future<String>>((t) async {
              final path =
                  "${assessment.type.name}/video/${t.startTime.getDateTimeInUtc().millisecondsSinceEpoch.toString()}.mp4";
              final download = storage.download(path: 'public/$path');
              final data = await download.result;
              return base64Encode(data.bytes);
            }) ??
            const Iterable<Future<String>>.empty()) ??
        const Iterable<Future<String>>.empty();

    try {
      return await Future.wait(videoFutures);
    } catch (e) {
      print('Error fetching videos: $e');
      return [];
    }
  }
}
