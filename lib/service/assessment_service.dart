import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/_service.dart';

class AssessmentService extends AppService {
  AssessmentService();

  Assessment createAssessment(
      AssessmentType type, DateTime now, String patientID) {
    return Assessment(
        patientID: patientID,
        type: type,
        timestamp: TemporalTimestamp.fromSeconds(
            now.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond));
  }

  Assessment addPDF(Assessment assessment, String pdf) {
    log("Adding pdf to assessment object");
    return assessment.copyWith(pdf: pdf);
  }

  Assessment addSequences(
      Assessment assessment, List<SkeletalSequence> sequences) {
    log("Adding skeletal sequences to assessment object");
    return assessment.copyWith(skeletalSequences: sequences);
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
