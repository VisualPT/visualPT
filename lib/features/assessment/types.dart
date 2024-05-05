import 'package:visualpt/models/ModelProvider.dart';

class ClinicalMeta {
  final String dateOfBirth;
  final Gender gender;
  final FallHistory fallHistory;
  final AssessmentType assessment;
  final bool obtrustion;
  final bool instability;
  final int condition;
  final int trial;

  const ClinicalMeta(
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
}
