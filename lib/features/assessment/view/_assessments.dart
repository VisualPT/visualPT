import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/models/ModelProvider.dart';
// import 'package:visualpt/features/assessment/view/gait/gait.dart';

/// The parameters that start with [seq] are used to define the individual sequences
/// the length of the Lists should be equal to the [sequences] parameter
abstract class BaseAssessment {
  AssessmentType get type;
  String get name;
  String get normalDuration;
  String get details;
  String get imagePath;

  int get sequences;
  List<String> get seqNames;
  List<List<String>> get seqInstructions;
  List<List<InferenceType>> get seqInference;
  List<bool> get seqObtrusion;
  List<bool> get seqInstability;
  Map<Map<String, String>, String> get formFields;
  bool get isTrainingData;
  bool get isAvailable;
}
