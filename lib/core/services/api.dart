import 'dart:developer';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class ApiService {
  static Future<GraphQLResponse<T>> read<T extends Model>(
      ModelType<T> type, ModelIdentifier<T> id) async {
    final request = ModelQueries.get(type, id);
    log(request.toJson().toString(), name: "API Service");
    final response = await Amplify.API.query(request: request).response;

    if (response.hasErrors && response.data == null) {
      throw Exception(
          "Error while fetching the assessment: ${response.errors}");
    }

    return response;
  }

  static Future<GraphQLResponse<PaginatedResult<T>>> list<T extends Model>(
      ModelType<T> type,
      {int limit = 100,
      QueryPredicate<Model>? where}) async {
    final request = ModelQueries.list(type, limit: limit, where: where);
    log(request.toJson().toString(), name: "API Service");
    final response = await Amplify.API.query(request: request).response;

    if (response.hasErrors && response.data == null) {
      throw Exception(
          "Error while fetching the assessment: ${response.errors}");
    }

    return response;
  }

  static Future<GraphQLResponse<T>> create<T extends Model>(T model) async {
    final request = ModelMutations.create(model);
    log(request.toJson().toString(), name: "API Service");
    final response = await Amplify.API.mutate(request: request).response;

// if the data is defined, lets just move on, as there will always be an error
    if (response.hasErrors && response.data == null) {
      throw Exception("Error while saving the assessment: ${response.errors}");
    }

    return response;
  }

  static Future<GraphQLResponse<T>> update<T extends Model>(T model) async {
    final request = ModelMutations.update(model);
    log(request.toJson().toString(), name: "API Service");
    final response = await Amplify.API.mutate(request: request).response;

    if (response.hasErrors && response.data == null) {
      throw Exception(
          "Error while updating the assessment: ${response.errors}");
    }

    return response;
  }
}
