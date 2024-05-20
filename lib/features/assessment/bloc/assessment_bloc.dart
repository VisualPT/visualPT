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
  final T config;
  late Subject subject;
  late Assessment assessment;
  DateTime startTime = DateTime.now();
  int conditionIndex = 0;
  int trialIndex = 0;
  bool storeData = true;

  AssessmentBloc(this.config) : super(AssessmentForm<T>(config)) {
    on<AssessmentInit>(_onInit);
    on<AssessmentCondition>(_onCondition);
    on<AssessmentTrial>(_onTrial);
  }

  FutureOr<void> _onInit(
      AssessmentInit event, Emitter<AssessmentState> emit) async {
    if (event.reset) {
      startTime = DateTime.now();
      conditionIndex = 0;
    }
    subject = event.subject;
    assessment = Assessment(
        subjectID: subject.id,
        type: config.type,
        duration: 0,
        datetime: TemporalDateTime(DateTime.now()),
        Conditions: []);
    final meta = ClinicalMeta(
        subject.dob.toString(),
        subject.gender,
        subject.fall_history,
        config.type,
        config.conditionObtrusion[conditionIndex],
        config.conditionInstability[conditionIndex],
        conditionIndex,
        1);
    emit(AssessmentActive<T>(
        meta, subject, conditionIndex, trialIndex, storeData, this.config));
  }

  FutureOr<void> _onCondition(
      AssessmentCondition event, Emitter<AssessmentState> emit) async {
    emit(AssessmentLoading<T>(config, conditionIndex));
    assessment.Conditions?.add(event.condition);
    assessment.copyWith(Conditions: assessment.Conditions);
    conditionIndex = conditionIndex + 1;
    await Future.delayed(const Duration(
        seconds:
            1)); //In order to get the InferenceBloc to rebuild, we have to do this for now so the state does not go from AssessmentActive->AssessmentActive with nothing intermediate
    if (conditionIndex == config.conditions) {
      final finishTime = DateTime.now();
      final double assessmentDurationSeconds =
          finishTime.difference(startTime).inMilliseconds / 1000;
// Create a new list of Conditions by adding the new Condition to the existing list
      List<Condition> updatedConditions =
          List.from(assessment.Conditions ?? []);
      updatedConditions.add(event.condition);
      assessment = assessment.copyWith(
          Conditions: updatedConditions, duration: assessmentDurationSeconds);
      emit(AssessmentAnalysis<T>(subject, storeData, assessment, config));
    } else {
      final meta = ClinicalMeta(
          subject.dob.toString(),
          subject.gender,
          subject.fall_history,
          config.type,
          config.conditionObtrusion[conditionIndex],
          config.conditionInstability[conditionIndex],
          conditionIndex,
          1);
      emit(AssessmentActive<T>(
          meta, subject, conditionIndex, trialIndex, storeData, config));
    }
  }

  FutureOr<void> _onTrial(
      AssessmentTrial event, Emitter<AssessmentState> emit) async {
    // Update the latest condition with the new trial
    List<Condition> conditions = List.from(assessment.Conditions ?? [])
      ..sort((a, b) => a.sequenceNumber.compareTo(b.sequenceNumber));
    emit(AssessmentLoading<T>(config, conditions.length));
    Condition latestCondition = conditions.removeLast();
    final trials = latestCondition.trials ?? [];
    trials.add(event.trial);
    latestCondition.copyWith(trials: trials);
    // If this is the last trial
    if (trials.length == config.trials) {
      // Add the completed condition to the assessment
      add(AssessmentCondition(latestCondition));
    } else {
      //
      final meta = ClinicalMeta(
          subject.dob.toString(),
          subject.gender,
          subject.fall_history,
          config.type,
          config.conditionObtrusion[conditionIndex],
          config.conditionInstability[conditionIndex],
          conditionIndex,
          1);
      emit(AssessmentActive<T>(meta, subject, conditions.length,
          latestCondition.trials?.length ?? 0, storeData, config));
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
