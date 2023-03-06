import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/_service.dart';

late Assessment? currentAssessment;

class AssessmentService extends AppService {
  AssessmentService();

  createAssessment(AssessmentType type, DateTime now, String patientID) {
    currentAssessment = Assessment(
        patientID: patientID,
        type: type,
        timestamp: TemporalTimestamp.fromSeconds(
            now.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond));
  }

  void addPDF(String pdf) {
    log("Adding pdf to assessment object");
    currentAssessment!.copyWith(pdf: pdf);
  }

  void addSequences(List<SkeletalSequence> sequences) {
    log("Adding skeletal sequences to assessment object");
    currentAssessment!.copyWith(skeletalSequences: sequences);
  }

  void addDuration(int durationSeconds) {
    log("Adding duration (in seconds) to assessment object");
    currentAssessment!.copyWith(duration: durationSeconds);
  }

  void save() {
    log("Saving assessment");
    saveData(currentAssessment!);
  }
}
