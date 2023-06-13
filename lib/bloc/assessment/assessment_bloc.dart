import 'dart:async';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/assessment_service.dart';
import 'package:visualpt/views/analysis_view.dart';
import 'package:visualpt/views/assessments/_assessments.dart';

part 'assessment_event.dart';
part 'assessment_state.dart';

class AssessmentBloc extends Bloc<AssessmentEvent, AssessmentState> {
  final AssessmentType type;

  late Assessment assessment;
  late Patient patient;
  late AssessmentRouter router;
  late int assessmentCount;
  late List<Widget Function(BuildContext) Function()> introViews;
  late List<Widget Function(BuildContext) Function(Patient)> captureViews;
  late List<Segment> segments = [];
  late DateTime startTime;
  late int index;

  AssessmentBloc(this.type) : super(AssessmentLoading()) {
    on<AssessmentInitial>(_onInitial);
    on<AssessmentBegin>(_onBegin);
    on<AssessmentIncrement>(_onIncrement);

    router = AssessmentRouter(type);
    assessmentCount = router.assessmentCount;
    introViews = router.introWidgets;
    captureViews = router.captureWidgets;
    startTime = DateTime.now();
    index = 0;
  }

  FutureOr<void> _onInitial(
      AssessmentInitial event, Emitter<AssessmentState> emit) async {
    event.reset && resetAssessment();
    patient = event.patient;
    assessment = AssessmentService().create(type, startTime, patient.id);
    emit(AssessmentIntro(index, introViews[index]()));
  }

  FutureOr<void> _onBegin(
      AssessmentBegin event, Emitter<AssessmentState> emit) {
    log("Beginning assessment segment $index");
    emit(AssessmentActive(index, captureViews[index](patient)));
  }

  FutureOr<void> _onIncrement(
      AssessmentIncrement event, Emitter<AssessmentState> emit) {
    segments.add(event.segment);
    index++;
    if (index == assessmentCount) {
      final int assessmentDurationSeconds =
          DateTime.now().difference(startTime).inSeconds;

      log("Time elapsed: $assessmentDurationSeconds seconds \nassests $segments");
      assessment = assessment.copyWith(
          segments: segments, duration: assessmentDurationSeconds);
      emit(AssessmentAnalysis(
          (_) => AnalysisView(assessment: assessment, patient: event.patient)));
    } else {
      emit(AssessmentIntro(index, introViews[index]()));
    }
  }

  resetAssessment() {
    //TODO we will want to use this data to retrain the model if it is of quality
    assessment = AssessmentService().create(type, startTime, patient.id);
    segments = [];
    index = 0;
    startTime = DateTime.now();
  }
}
