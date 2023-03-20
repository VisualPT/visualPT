import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/assessment_service.dart';
import 'package:visualpt/views/analysis_view.dart';
import 'package:visualpt/views/assessments/_assessments.dart';

part 'assessment_event.dart';
part 'assessment_state.dart';

class AssessmentBloc extends Bloc<AssessmentEvent, AssessmentState> {
  final AssessmentType assessmentType;

  late Assessment assessment;
  late AssessmentRouter assessmentRouter;
  late int assessmentCount;
  late List<Widget Function(BuildContext) Function(String)> introViews;
  late List<Widget Function(BuildContext) Function(String)> captureViews;
  late Map<dynamic, String> assessmentAssets = {};
  late List<SkeletalSequence> skeletalSequences = [];
  late DateTime assessmentStart = DateTime.now();
  late int assessmentDurationSeconds; //TODO store this in Amplify
  late int index = 0;

  AssessmentBloc(this.assessmentType) : super(AssessmentForm(assessmentType)) {
    on<AssessmentInit>(_onInit);
    on<AssessmentBegin>(_onBegin);
    on<AssessmentIncrement>(_onIncrement);

    assessmentRouter = AssessmentRouter(assessmentType);
    assessmentCount = assessmentRouter.assessmentCount;
    introViews = assessmentRouter.introWidgets;
    captureViews = assessmentRouter.captureWidgets;
  }

  FutureOr<void> _onInit(AssessmentInit event, Emitter<AssessmentState> emit) {
    log("Beginning assessment segment $index");
    event.index == 0
        ? assessment = AssessmentService()
            .createAssessment(assessmentType, DateTime.now(), event.patient.id)
        : null;
    emit(AssessmentIntro(index, introViews[index](assessmentType.name)));
  }

  FutureOr<void> _onBegin(
      AssessmentBegin event, Emitter<AssessmentState> emit) {
    log("Beginning assessment segment $index");
    emit(AssessmentActive(index, captureViews[index](assessmentType.name)));
  }

  FutureOr<void> _onIncrement(
      AssessmentIncrement event, Emitter<AssessmentState> emit) {
    //TODO add map to assessmentassets
    index++;
    if (index == assessmentCount) {
      assessmentDurationSeconds =
          DateTime.now().difference(assessmentStart).inSeconds;

      log("Time elapsed: $assessmentDurationSeconds seconds \nassests $assessmentAssets");
      AssessmentService().addDuration(assessment, assessmentDurationSeconds);

      emit(AssessmentSuccess(
          assessmentAssets,
          (context) => AnalysisView(
              assessment: assessment, assessmentAssets: assessmentAssets)));
    } else {
      emit(AssessmentIntro(index, introViews[index](assessmentType.name)));
    }
  }
}
