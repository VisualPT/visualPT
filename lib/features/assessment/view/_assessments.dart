import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/assessment/view/ctsib/ctsib.dart';
import 'package:visualpt/features/assessment/view/berg/berg.dart';
// import 'package:visualpt/features/assessment/view/gait/gait.dart';

class AssessmentRouter {
  AssessmentRouter();

  static BaseAssessment getAssessment(AssessmentType type) {
    switch (type) {
      case AssessmentType.CTSIB:
        return CTSIB();
      case AssessmentType.BERG:
        return BERG();
      // case AssessmentType.GAIT:
      //   return GAIT();
      default:
        throw Exception("Invalid Assessment Type");
    }
  }
}

/// The parameters that start with [seq] are used to define the individual sequences
/// the length of the Lists should be equal to the [sequences] parameter
class BaseAssessment {
  final AssessmentType type;
  final int sequences;
  final List<String> seqNames;
  final List<List<String>> seqInstructions;
  final List<List<InferenceType>> seqInference;
  final Map<Map<String, String>, String> formFields;
  final bool isTrainingData;

  BaseAssessment(
      {required this.type,
      required this.sequences,
      required this.seqNames,
      required this.seqInstructions,
      required this.seqInference,
      required this.formFields,
      required this.isTrainingData});
}
