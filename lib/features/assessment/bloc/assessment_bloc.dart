import 'dart:async';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';

part 'assessment_event.dart';
part 'assessment_state.dart';

//Clean this up with a repository layer
class AssessmentBloc<T extends BaseAssessment>
    extends Bloc<AssessmentEvent, AssessmentState<T>> {
  final T assessmentParams;
  late Assessment dbAssessment;
  late Patient patient;
  late DateTime startTime;
  List<Segment> segments = [];

  AssessmentBloc(this.assessmentParams)
      : super(AssessmentForm<T>(assessmentParams)) {
    on<AssessmentInit>(_onInit);
    on<AssessmentIncrement>(_onIncrement);

    startTime = DateTime.now();
  }

  FutureOr<void> _onInit(
      AssessmentInit event, Emitter<AssessmentState> emit) async {
    if (event.reset) resetAssessment();
    patient = event.patient;
    dbAssessment = Assessment(
        patientID: patient.id,
        type: assessmentParams.type,
        datetime: TemporalDateTime(DateTime.now()),
        segments: segments);
    emit(AssessmentActive<T>(
        patient, event.storeData, 0, this.assessmentParams));
  }

  FutureOr<void> _onIncrement(
      AssessmentIncrement event, Emitter<AssessmentState> emit) {
    segments.add(event.segment);
    int index = event.index + 1;

    if (index == assessmentParams.sequences) {
      final finishTime = DateTime.now();
      final int assessmentDurationSeconds =
          finishTime.difference(startTime).inSeconds;
      dbAssessment = dbAssessment.copyWith(
          segments: segments, duration: assessmentDurationSeconds);
      emit(AssessmentAnalysis<T>(
          patient, event.storeData, dbAssessment, assessmentParams));
    } else {
      emit(AssessmentActive<T>(
          patient, event.storeData, index, assessmentParams));
    }
  }

  void resetAssessment() {
    //TODO we will want to use this data to retrain the model if it is of quality
    dbAssessment = Assessment(
        patientID: patient.id,
        type: assessmentParams.type,
        datetime: TemporalDateTime(DateTime.now()),
        segments: segments);
    segments = [];
    startTime = DateTime.now();
  }
}
