import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/_service.dart';

late Assessment? currentAssessment;

class AssessmentService extends AppService {
  AssessmentService();

  createAssessment(
      AssessmentType type, DateTime now, String pdf, String patientID) {
    currentAssessment = Assessment(
        type: type,
        timestamp: TemporalTimestamp.fromSeconds(
            now.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond),
        pdf_base64: pdf,
        patientID: patientID);
  }

  void save() {
    saveData(currentAssessment!);
  }
}
