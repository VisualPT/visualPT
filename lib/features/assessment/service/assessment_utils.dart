import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/features/capture/service/pose_detection_output.dart';
import 'package:visualpt/models/ModelProvider.dart';

class AssessmentUtils {
  static BaseAssessment getConfig(AssessmentType type) {
    switch (type) {
      case AssessmentType.CTSIB:
        return CTSIB();
      case AssessmentType.MCTSIB:
        return MCTSIB();
      case AssessmentType.BERG:
        return BERG();
      case AssessmentType.GAIT:
        return GAIT();
      case AssessmentType.REACH:
        return REACH();
      case AssessmentType.FIST:
        return FIST();
      case AssessmentType.DEV:
        return DEV();
    }
  }

  static double getAvgDuration(List<Trial>? trials) {
    return trials?.fold<double>(0.0,
            (previousValue, element) => previousValue + element.duration) ??
        0.0 / (trials?.length ?? 1);
  }

  static double getTotalAverageDuration(Assessment assessment) {
    if (assessment.stages == null || assessment.stages!.isEmpty) {
      return 0.0;
    }

    double totalDuration = 0.0;

    for (var stage in assessment.stages!) {
      if (stage.trials != null && stage.trials!.isNotEmpty) {
        double conditionTotalDuration = stage.trials!
            .map((trial) => trial.duration)
            .reduce((a, b) => a + b);
        double conditionAverageDuration =
            conditionTotalDuration / stage.trials!.length;
        totalDuration += conditionAverageDuration;
      }
    }

    return totalDuration;
  }
}

void updateNorms(
    BaseAssessment assessmentMeta, Assessment assessment, Profile profile) {
  final equilibriumScores = assessmentMeta.calculateScores(assessment);
  int seqNum = 0;
  for (var score in equilibriumScores) {
    assessmentMeta.setNorm(
        profile.dob, profile.gender, seqNum, score, assessmentMeta.trials);
    seqNum++;
  }
}

AgeRange getAgeEnumByTemporalDate(TemporalDate birthDate) {
  DateTime birthDateTime =
      birthDate.getDateTime(); // Assuming getDateTime() gives a DateTime object
  DateTime today = DateTime.now();

  int age = today.year - birthDateTime.year;

  // Check if the birthday hasn't occurred yet this year
  if (today.month < birthDateTime.month ||
      (today.month == birthDateTime.month && today.day < birthDateTime.day)) {
    age--;
  }

  // Determine the AgeRange based on the calculated age
  if (age >= 0 && age <= 5) {
    return AgeRange.BABY_0_5;
  } else if (age >= 6 && age <= 12) {
    return AgeRange.CHILD_6_12;
  } else if (age >= 13 && age <= 19) {
    return AgeRange.TEEN_13_19;
  } else if (age >= 20 && age <= 39) {
    return AgeRange.ADULT_20_39;
  } else if (age >= 40 && age <= 64) {
    return AgeRange.ADULT_40_64;
  } else if (age >= 65 && age <= 69) {
    return AgeRange.SENIOR_65_69;
  } else if (age >= 70 && age <= 79) {
    return AgeRange.SENIOR_70_79;
  } else if (age >= 80 && age <= 84) {
    return AgeRange.SENIOR_80_84;
  } else if (age >= 85 && age <= 89) {
    return AgeRange.SENIOR_85_PLUS;
  } else {
    throw ArgumentError('Age out of range for defined AgeRange enums');
  }
}
