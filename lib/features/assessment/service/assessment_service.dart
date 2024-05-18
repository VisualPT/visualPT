import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/backend/service/datastore_service.dart';

class AssessmentService extends DataStoreService<Assessment> {
  AssessmentService();

  @override
  void create(Assessment entity) {
    log("Saving assessment");
    super.create(entity);
  }

  @override
  void delete(Assessment entity) {
    Amplify.DataStore.delete(entity);
  }

  Assessment addPDF(Assessment assessment, Uint8List rawPdf) {
    log("Adding pdf to assessment object");
    String base64String = base64Encode(rawPdf);
    String header = 'data:application/pdf;base64,';
    final pdf = header + base64String;
    return assessment.copyWith(pdf: pdf);
  }

  Assessment addConditions(Assessment assessment, List<Condition> conditions) {
    log("Adding conditions to assessment object");
    //Add all the incomong conditions to the existing conditions in the assessment
    conditions.addAll(assessment.Conditions ?? []);
    return assessment.copyWith(Conditions: conditions);
  }

  Assessment addDuration(Assessment assessment, double durationSeconds) {
    log("Adding duration (in seconds) to assessment object");
    return assessment.copyWith(duration: durationSeconds);
  }
}
