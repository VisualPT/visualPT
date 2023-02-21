import 'package:flutter/cupertino.dart';
import 'package:visualpt/models/ModelProvider.dart';

import 'package:visualpt/views/assessments/ctsib/ctsib.dart';
import 'package:visualpt/views/assessments/gait/gait.dart';

class AssessmentRouter {
  final AssessmentType assessmentType;

  late List<Widget Function(BuildContext, String)> introWidgets;
  late List<Widget Function(BuildContext, String)> captureWidgets;

  late int assessmentCount;

  AssessmentRouter(this.assessmentType) {
    try {
      switch (assessmentType) {
        case AssessmentType.CTSIB:
          introWidgets = Ctsib().introContent();
          captureWidgets = Ctsib().captureContent();

          assessmentCount = Ctsib.sequences;
          break;
        case AssessmentType.GAIT:
          //TODO assessmentWidgets = Gait().content();
          assessmentCount = Gait().sequences;

          break;
        default:
          throw Exception("Invalid Assessment Type");
      }
    } catch (e) {
      //TODO Dont progress to the assessment page
    }
  }
}
