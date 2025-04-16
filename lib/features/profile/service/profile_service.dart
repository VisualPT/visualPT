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

  static Future<List<Assessment>> queryAssessmentsByProfileId(String id,
      {AssessmentType? type, bool getAll = true}) async {
    final predicate = type != null
        ? Assessment.PROFILE.eq(id).and(Assessment.TYPE.eq(type))
        : Assessment.PROFILE.eq(id);

    final response = await ApiService.list<Assessment>(Assessment.classType,
        where: predicate, getAll: getAll);

    final assessments = FormatUtil.filterList<Assessment>(response.data?.items);
    return assessments;
  }

  static void deleteAssessment(Assessment assessment) {
    ApiService.delete<Assessment>(assessment);
  }

  static Future<Profile?> getProfile(String? id) async {
    if (id == null) {
      return null;
    }
    final response = await ApiService.read<Profile>(
        Profile.classType, ProfileModelIdentifier(id: id));
    return response.data;
  }
}
