import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/models/ModelProvider.dart';
// import 'package:visualpt/features/assessment/view/gait/gait.dart';

/// The parameters that start with [seq] are used to define the individual sequences
/// the length of the Lists should be equal to the [conditions] parameter
abstract class BaseAssessment {
  AssessmentType get type;
  String get name;
  String get normalDuration;
  String get details;
  String get imagePath;

  int get conditions;
  int get trials;
  int get trialDuration;
  List<String> get conditionNames;
  List<List<String>> get conditionInstructions;
  List<List<InferenceType>> get conditionInference;
  List<bool> get conditionObtrusion;
  List<bool> get conditionInstability;
  Map<Map<String, String>, String> get formFields;
  bool get isTrainingData;
  bool get isAvailable;

  Future<List<Norm>?> getNorms(TemporalDate dob, Gender gender) {
    return Future.value(null);
  }

  Future<Norm?> setNorm(
      TemporalDate dob, Gender gender, int seqNum, double score, int trials) {
    return Future.value();
  }

  List<double> calculateScores(Assessment assessment) {
    return List.filled(0, 0.0);
  }

  String getNormativeMessage(Assessment assessment, List<Norm>? norms) {
    return "Default Normative Message";
  }
}

void updateNorms(
    BaseAssessment assessmentMeta, Assessment assessment, Subject subject) {
  final equilibriumScores = assessmentMeta.calculateScores(assessment);
  int seqNum = 0;
  for (var score in equilibriumScores) {
    assessmentMeta.setNorm(
        subject.dob, subject.gender, seqNum, score, assessmentMeta.trials);
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
    return AgeRange.SENIOR_85_89;
  } else {
    throw ArgumentError('Age out of range for defined AgeRange enums');
  }
}
