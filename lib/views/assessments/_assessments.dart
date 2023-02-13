import 'package:flutter/cupertino.dart';
import 'package:visualpt/models/ModelProvider.dart';

import 'package:visualpt/views/assessments/ctsib.dart';
import 'package:visualpt/views/assessments/gait.dart';

export 'ctsib.dart';
export 'gait.dart';

class AssessmentRouter {
  final AssessmentType assessmentType;
  late List<Widget> assessmentRoute;

  AssessmentRouter(this.assessmentType) {
    switch (assessmentType) {
      case AssessmentType.CTSIB:
        assessmentRoute = Ctsib().content;
        break;
      case AssessmentType.GAIT:
        assessmentRoute = Gait().content;
        break;
      default:
    }
  }
}
