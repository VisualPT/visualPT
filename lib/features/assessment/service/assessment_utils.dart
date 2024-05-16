import 'package:visualpt/features/assessment/config/berg/berg.dart';
import 'package:visualpt/features/assessment/config/ctsib/ctsib.dart';
import 'package:visualpt/features/assessment/config/fist/fist.dart';
import 'package:visualpt/features/assessment/config/gait/gait.dart';
import 'package:visualpt/features/assessment/config/reach/reach.dart';
import 'package:visualpt/features/assessment/view/assessment_view.dart';
import 'package:visualpt/models/AssessmentType.dart';

class AssessmentUtils {
  static AssessmentView getView(AssessmentType type) {
    switch (type) {
      case AssessmentType.CTSIB:
        return AssessmentView(CTSIB());
      case AssessmentType.BERG:
        return AssessmentView(BERG());
      case AssessmentType.GAIT:
        return AssessmentView(GAIT());
      case AssessmentType.REACH:
        return AssessmentView(REACH());
      case AssessmentType.FIST:
        return AssessmentView(FIST());
    }
  }
}
