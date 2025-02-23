import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:visualpt/models/ModelProvider.dart';

class AssessmentService {
  Assessment updateAssessmentPdf(Assessment assessment, Uint8List rawPdf) {
    log("Adding pdf to assessment object");
    String base64String = base64Encode(rawPdf);
    String header = 'data:application/pdf;base64,';
    final pdf = header + base64String;
    return assessment.copyWith(pdf: pdf);
  }
}
