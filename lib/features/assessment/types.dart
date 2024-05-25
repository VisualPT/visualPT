import 'package:visualpt/features/assessment/service/form_helper.dart';
import 'package:visualpt/models/ModelProvider.dart';

class AssessmentMeta {
  final String dateOfBirth;
  final Gender gender;
  final FallHistory fallHistory;
  final AssessmentType assessment;
  final bool obtrustion;
  final bool instability;
  final int condition;
  final int trial;

  const AssessmentMeta(
    this.dateOfBirth,
    this.gender,
    this.fallHistory,
    this.assessment,
    this.obtrustion,
    this.instability,
    this.condition,
    this.trial,
  );

  String csv() {
    return "$dateOfBirth,${gender.name},${fallHistory.name},${assessment.name},$obtrustion,$instability,$condition,$trial";
  }

  static fromCSV(String removeAt) {
    final parts = removeAt.split(",");
    return AssessmentMeta(
      parts[0],
      FormHelper.genderParse(parts[1]),
      FormHelper.fallHistoryParse(parts[2]),
      FormHelper.assessmentTypeParse(parts[3]),
      parts[4] == "true",
      parts[5] == "true",
      int.parse(parts[6]),
      int.tryParse(parts[7]) ?? 1,
    );
  }
}
