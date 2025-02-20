import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:visualpt/models/ModelProvider.dart';

class AssessmentService {
  Assessment addPDF(Assessment assessment, Uint8List rawPdf) {
    log("Adding pdf to assessment object");
    String base64String = base64Encode(rawPdf);
    String header = 'data:application/pdf;base64,';
    final pdf = header + base64String;
    return assessment.copyWith(pdf: pdf);
  }

  Assessment addStages(Assessment assessment, List<Stage> stages) {
    log("Adding stages to assessment object");
    //Add all the incomong conditions to the existing conditions in the assessment
    stages.addAll(assessment.stages ?? []);
    return assessment.copyWith(stages: stages);
  }

  Assessment addDuration(Assessment assessment, double durationSeconds) {
    log("Adding duration (in seconds) to assessment object");
    return assessment.copyWith(duration: durationSeconds);
  }
}
