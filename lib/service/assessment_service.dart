import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/_service.dart';

class AssessmentService extends AppService {
  AssessmentService();

  Assessment create(AssessmentType type, DateTime now, String patientID) {
    return Assessment(
        patientID: patientID, type: type, datetime: TemporalDateTime(now));
  }

  void delete(Assessment assessment) {
    Amplify.DataStore.delete(assessment);
  }

  Assessment addPDF(Assessment assessment, Uint8List rawPdf) {
    log("Adding pdf to assessment object");
    String base64String = base64Encode(rawPdf);
    String header = 'data:application/pdf;base64,';
    final pdf = header + base64String;
    return assessment.copyWith(pdf: pdf);
  }

  Assessment addSegments(Assessment assessment, List<Segment> segments) {
    log("Adding segments to assessment object");
    return assessment.copyWith(segments: segments);
  }

  Assessment addDuration(Assessment assessment, int durationSeconds) {
    log("Adding duration (in seconds) to assessment object");
    return assessment.copyWith(duration: durationSeconds);
  }

  void save(Assessment assessment) {
    log("Saving assessment");
    saveData(assessment);
  }
}
