import 'dart:async';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt_collector/models/ModelProvider.dart';
import 'package:visualpt_collector/features/assessment/view/_assessments.dart';

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
  int conditionIndex = 0;
  bool storeData = false;

  AssessmentBloc(this.assessmentParams)
      : super(AssessmentForm<T>(assessmentParams)) {
    on<AssessmentInit>(_onInit);
    on<AssessmentIncrement>(_onIncrement);

    startTime = DateTime.now();
  }

  FutureOr<void> _onInit(
      AssessmentInit event, Emitter<AssessmentState> emit) async {
    if (event.reset) {
      dbAssessment = Assessment(
          patientID: patient.id,
          type: assessmentParams.type,
          datetime: TemporalDateTime(DateTime.now()),
          segments: segments);
      segments = [];
      startTime = DateTime.now();
      conditionIndex = 0;
    }
    patient = event.patient;
    storeData = event.storeData;
    dbAssessment = Assessment(
        patientID: patient.id,
        type: assessmentParams.type,
        datetime: TemporalDateTime(DateTime.now()),
        segments: segments);
    emit(AssessmentActive<T>(
        patient, storeData, conditionIndex, this.assessmentParams));
  }

  FutureOr<void> _onIncrement(
      AssessmentIncrement event, Emitter<AssessmentState> emit) async {
    emit(AssessmentLoading<T>(assessmentParams, conditionIndex));
    segments.add(event.segment);
    conditionIndex = conditionIndex + 1;
    await Future.delayed(const Duration(
        seconds:
            1)); //In order to get the InferenceBloc to rebuild, we have to do this for now so the state does not go from AssessmentActive->AssessmentActive with nothing intermediate
    if (conditionIndex == assessmentParams.sequences) {
      final finishTime = DateTime.now();
      final int assessmentDurationSeconds =
          finishTime.difference(startTime).inSeconds;
      dbAssessment = dbAssessment.copyWith(
          segments: segments, duration: assessmentDurationSeconds);
      emit(AssessmentAnalysis<T>(
          patient, storeData, dbAssessment, assessmentParams));
    } else {
      emit(AssessmentActive<T>(
          patient, storeData, conditionIndex, assessmentParams));
    }
  }

  // @override
  // void onTransition(
  //     Transition<AssessmentEvent, AssessmentState<T>> transition) {
  //   // Always call super.onTransition with the current transition
  //   super.onTransition(transition);
  //   debugPrint('AssessmentBloc: $transition');
  // }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // Always call super.onError with the current error
    super.onError(error, stackTrace);
    debugPrint('AssessmentBloc: $error');
  }
}
