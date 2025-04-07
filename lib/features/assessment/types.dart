import 'package:visualpt/features/assessment/service/form_helper.dart';
import 'package:visualpt/models/ModelProvider.dart';

class TrialMeta {
  final String dateOfBirth;
  final Gender gender;
  final AssessmentType assessment;
  final bool obtrustion;
  final bool instability;
  final int stage;
  final int trial;
  final int trials;
  final int duration;
  final bool store;

  const TrialMeta(
      this.dateOfBirth,
      this.gender,
      this.assessment,
      this.obtrustion,
      this.instability,
      this.stage,
      this.trial,
      this.trials,
      this.duration,
      this.store);

  String csv() {
    return "$dateOfBirth,${gender.name},${assessment.name},$obtrustion,$instability,$stage,$trial,$trials,$duration,$store";
  }

  static fromCSV(String removeAt) {
    final parts = removeAt.split(",");
    return TrialMeta(
      parts[0],
      FormHelper.genderParse(parts[1]),
      FormHelper.assessmentTypeParse(parts[3]),
      parts[4] == "true",
      parts[5] == "true",
      int.parse(parts[6]),
      int.tryParse(parts[7]) ?? 1,
      int.tryParse(parts[8]) ?? 1,
      int.tryParse(parts[9]) ?? 0,
      bool.tryParse(parts[10]) ?? true,
    );
  }
}

class DetectionParams {
  final (double, double) sensitivity;
  final (double, double) offset;

  const DetectionParams(
      {this.sensitivity = (1.0, 1.0), this.offset = (0.0, 0.0)});
}
