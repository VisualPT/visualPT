import 'dart:async';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/assessment/types.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';

part 'assessment_event.dart';
part 'assessment_state.dart';

//Clean this up with a repository layer
class AssessmentBloc<T extends BaseAssessment>
    extends Bloc<AssessmentEvent, AssessmentState<T>> {
  final T assessmentParams;
  late Assessment dbAssessment;
  late Subject subject;
  late DateTime startTime;
  List<Condition> conditions = [];
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
      //TODO these should be created at the END of the assessment with all of the aggregated data, not the beginning?
      dbAssessment = Assessment(
          subjectID: subject.id,
          type: assessmentParams.type,
          datetime: TemporalDateTime(DateTime.now()),
          duration: 0,
          Conditions: conditions);
      conditions = [];
      startTime = DateTime.now();
      conditionIndex = 0;
    }
    subject = event.subject;
    storeData = event.storeData;
    dbAssessment = Assessment(
        subjectID: subject.id,
        type: assessmentParams.type,
        duration: 0,
        datetime: TemporalDateTime(DateTime.now()),
        Conditions: conditions);
    final meta = ClinicalMeta(
        subject.dob.toString(),
        subject.gender,
        subject.fall_history,
        assessmentParams.type,
        assessmentParams.seqObtrusion[conditionIndex],
        assessmentParams.seqInstability[conditionIndex],
        conditionIndex,
        1);
    emit(AssessmentActive<T>(
        meta, subject, storeData, conditionIndex, this.assessmentParams));
  }

  FutureOr<void> _onIncrement(
      AssessmentIncrement event, Emitter<AssessmentState> emit) async {
    emit(AssessmentLoading<T>(assessmentParams, conditionIndex));
    conditions.add(event.condition);
    conditionIndex = conditionIndex + 1;
    await Future.delayed(const Duration(
        seconds:
            1)); //In order to get the InferenceBloc to rebuild, we have to do this for now so the state does not go from AssessmentActive->AssessmentActive with nothing intermediate
    if (conditionIndex == assessmentParams.sequences) {
      final finishTime = DateTime.now();
      final double assessmentDurationSeconds =
          finishTime.difference(startTime).inMilliseconds / 1000;
      dbAssessment = dbAssessment.copyWith(
          Conditions: conditions, duration: assessmentDurationSeconds);
      emit(AssessmentAnalysis<T>(
          subject, storeData, dbAssessment, assessmentParams));
    } else {
      final meta = ClinicalMeta(
          subject.dob.toString(),
          subject.gender,
          subject.fall_history,
          assessmentParams.type,
          assessmentParams.seqObtrusion[conditionIndex],
          assessmentParams.seqInstability[conditionIndex],
          conditionIndex,
          1);
      emit(AssessmentActive<T>(
          meta, subject, storeData, conditionIndex, assessmentParams));
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
    debugPrint('AssessmentBloc: $stackTrace, $error');
  }
}
