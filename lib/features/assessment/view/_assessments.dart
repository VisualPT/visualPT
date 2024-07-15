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
}
