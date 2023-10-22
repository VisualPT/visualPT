import 'dart:async';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/analysis/view/analysis_view.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';

part 'assessment_event.dart';
part 'assessment_state.dart';

//Clean this up with a repository layer
class AssessmentBloc extends Bloc<AssessmentEvent, AssessmentState> {
  final AssessmentType type;

  late Assessment assessment;
  late Patient patient;
  late int assessmentCount;
  late List<Widget Function(BuildContext) Function()> introViews;
  late List<Widget Function(BuildContext) Function(Patient)> captureViews;
  late List<Segment> segments = [];
  late DateTime startTime;

  AssessmentBloc(this.type) : super(AssessmentLoading()) {
    on<AssessmentInitial>(_onInitial);
    on<AssessmentBegin>(_onBegin);
    on<AssessmentIncrement>(_onIncrement);

    final router = AssessmentRouter(type);
    assessmentCount = router.assessmentCount;
    introViews = router.introWidgets;
    captureViews = router.captureWidgets;

    startTime = DateTime.now();
  }

  FutureOr<void> _onInitial(
      AssessmentInitial event, Emitter<AssessmentState> emit) async {
    if (event.reset) resetAssessment();
    patient = event.patient;
    assessment = Assessment(
        patientID: patient.id,
        type: type,
        datetime: TemporalDateTime(DateTime.now()),
        segments: segments);
    emit(AssessmentIntro(0, introViews[0]()));
  }

  FutureOr<void> _onBegin(
      AssessmentBegin event, Emitter<AssessmentState> emit) {
    emit(AssessmentActive(event.index, captureViews[event.index - 1](patient)));
  }

  FutureOr<void> _onIncrement(
      AssessmentIncrement event, Emitter<AssessmentState> emit) {
    segments.add(event.segment);
    int index = event.index + 1;

    if (index - 1 == assessmentCount) {
      final finishTime = DateTime.now();
      final int assessmentDurationSeconds =
          finishTime.difference(startTime).inSeconds;
      assessment = assessment.copyWith(
          segments: segments, duration: assessmentDurationSeconds);
      emit(AssessmentAnalysis(
          (_) => AnalysisView(assessment: assessment, patient: event.patient)));
    } else {
      emit(AssessmentIntro(index, introViews[index - 1]()));
    }
  }

  resetAssessment() {
    //TODO we will want to use this data to retrain the model if it is of quality
    assessment = Assessment(
        patientID: patient.id,
        type: type,
        datetime: TemporalDateTime(DateTime.now()),
        segments: segments);
    segments = [];
    startTime = DateTime.now();
  }
}
