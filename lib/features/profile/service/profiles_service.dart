import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/models/ModelProvider.dart';

class ProfilesService {
  static Future<List<Profile?>> queryListProfiles() async {
    try {
      final request = ModelQueries.list(Profile.classType);
      final response = await Amplify.API.query(request: request).response;

      final profiles = response.data?.items;
      if (profiles == null) {
        safePrint('errors: ${response.errors}');
        return const [];
      }
      return profiles;
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return const [];
    }
  }

  static Future<Profile?> create(Profile profile) async {
    try {
      final request = ModelMutations.create(profile);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.data == null) {
        safePrint('errors: ${response.errors}');
        return null;
      }
      return response.data;
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return null;
    }
  }

  static Future<Profile?> update(Profile profile, String? id) async {
    try {
      final request = ModelMutations.update(profile);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.data == null) {
        safePrint('errors: ${response.errors}');
        return null;
      }
      return response.data;
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return null;
    }
  }

  static Future<Profile?> delete(Profile profile, String? id) async {
    try {
      final request = ModelMutations.delete(profile);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.data == null) {
        safePrint('errors: ${response.errors}');
        return null;
      }
      return response.data;
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return null;
    }
  }

  static Stream<GraphQLResponse<Profile>> subscribe() {
    final subscriptionRequest = ModelSubscriptions.onCreate(Profile.classType);
    final Stream<GraphQLResponse<Profile>> operation = Amplify.API
        .subscribe(
          subscriptionRequest,
          onEstablished: () => safePrint('Subscription established'),
        )
        // Listens to only 30 elements
        .take(30)
        .handleError(
      (Object error) {
        safePrint('Error in subscription stream: $error');
      },
    );
    return operation;
  }
}
