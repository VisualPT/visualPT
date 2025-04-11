import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/models/ModelProvider.dart';

class ProfileService {
  static Future<List<Profile?>> list() async {
    try {
      final response = await ApiService.list(Profile.classType, getAll: true);
      final profiles = response.data?.items ?? [];
      return profiles;
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return const [];
    }
  }

  static Future<List<Assessment>> queryAssessmentsByProfileId(String id) async {
    final response = await ApiService.list<Assessment>(Assessment.classType,
        where: Assessment.PROFILE.eq(id), getAll: true);
    final assessments = FormatUtil.filterList<Assessment>(response.data?.items);
    return assessments;
  }
}
