import 'package:visualpt/features/assessment/view/assessment_view.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/assessment/view/ctsib/ctsib.dart';
import 'package:visualpt/features/assessment/view/berg/berg.dart';
// import 'package:visualpt/features/assessment/view/gait/gait.dart';

class AssessmentRouter {
  AssessmentRouter();

  static AssessmentView getAssessmentView(AssessmentType type) {
    switch (type) {
      case AssessmentType.CTSIB:
        return AssessmentView(CTSIB());
      case AssessmentType.BERG:
        return AssessmentView(BERG());
      case AssessmentType.GAIT:
        // return AssessmentView(GAIT());
        break;
    }
    throw Exception("Invalid Assessment Type for requested type T");
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
