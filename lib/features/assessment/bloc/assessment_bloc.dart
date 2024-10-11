import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart' as amplify;
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
  Condition? currentCondition;
  DateTime assessmentStartTime = DateTime.now();
  DateTime conditionStartTime = DateTime.now();

  bool storeData = true;

  AssessmentBloc(this.config) : super(AssessmentForm<T>(config)) {
    on<AssessmentInit>(_onInit);
    on<AssessmentCondition>(_onCondition);
    on<AssessmentTrial>(_onTrial);
  }

  FutureOr<void> _onInit(
      AssessmentInit event, Emitter<AssessmentState> emit) async {
    assessmentStartTime = DateTime.now();
    subject = event.subject;
    // amplify.Amplify.DataStore.save(subject);
    assessment = Assessment(
        subjectID: subject.id,
        type: config.type,
        duration: 0,
        datetime: amplify.TemporalDateTime(DateTime.now()),
        Conditions: null);
    // amplify.Amplify.DataStore.save(assessment);
    conditionStartTime = DateTime.now();
    currentCondition = Condition(
        assessmentID: assessment.id,
        duration: 0,
        sequenceNumber: 0,
        trials: null);
    // amplify.Amplify.DataStore.save(currentCondition!);
    emit(AssessmentActive<T>(
        getMeta(subject, config, 0, 0), subject, event.storeData, this.config));
  }

  FutureOr<void> _onCondition(
      AssessmentCondition event, Emitter<AssessmentState> emit) async {
    emit(AssessmentLoading<T>(assessment.Conditions?.length ?? 0, config));
    currentCondition = currentCondition?.copyWith(
        duration: getElapsedSeconds(conditionStartTime));
    // amplify.Amplify.DataStore.save(currentCondition!);
    await Future.delayed(const Duration(
        seconds:
            1)); //In order to get the InferenceBloc to rebuild, we have to do this for now so the state does not go from AssessmentActive->AssessmentActive with nothing intermediate
    final newConditions = List<Condition>.from(
        [...(assessment.Conditions ?? []), currentCondition]);
    //Reset the current condition object
    currentCondition = Condition(
        assessmentID: assessment.id,
        duration: 0,
        sequenceNumber: newConditions.length - 1,
        trials: null);
    // amplify.Amplify.DataStore.save(currentCondition!);
    if (assessment.Conditions?.length == config.conditions) {
      final double assessmentDurationSeconds =
          getElapsedSeconds(assessmentStartTime);
      assessment = assessment.copyWith(duration: assessmentDurationSeconds);
      // amplify.Amplify.DataStore.save(assessment);
      emit(AssessmentAnalysis<T>(subject, storeData, assessment, config));
    } else {
      conditionStartTime = DateTime.now();
      emit(AssessmentActive<T>(
          getMeta(subject, config, assessment.Conditions?.length ?? 0, 0),
          subject,
          storeData,
          config));
    }
  }

  FutureOr<void> _onTrial(
      AssessmentTrial event, Emitter<AssessmentState> emit) async {
    // Update the latest condition with the new trial
    final trial = Trial(
        conditionID: currentCondition?.id ?? "Error ID",
        start_time: event.startTime,
        duration: event.duration.inMilliseconds / 1000, //seconds
        Detections: event.detections);
    // try {
    //   amplify.Amplify.DataStore.save(trial);
    // } on Exception catch (e) {
    //   print("Error saving trial: $e");
    // }
    currentCondition = currentCondition == null
        ? Condition(
            assessmentID: assessment.id,
            duration: 0,
            sequenceNumber: assessment.Conditions?.length ?? 0,
            trials: [trial])
        : currentCondition
            ?.copyWith(trials: [...currentCondition?.trials ?? [], trial]);

    //Check if its the last trial
    if (currentCondition?.trials?.length == config.trials) {
      currentCondition = currentCondition?.copyWith(
          duration: getElapsedSeconds(conditionStartTime));
      final List<Condition> allConditions = [
        ...(assessment.Conditions ?? []),
        currentCondition!
      ];
      assessment = assessment.copyWith(Conditions: allConditions);
      add(AssessmentCondition());
      return;
    }

    //If it is not, then we need to update the state to show the next trial

    //
    emit(AssessmentActive<T>(
        getMeta(
          subject,
          config,
          assessment.Conditions?.length ?? 0,
          currentCondition?.trials?.length ?? 0,
        ),
        subject,
        storeData,
        config));
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

double getElapsedSeconds(DateTime start) {
  return DateTime.now().difference(start).inMilliseconds / 1000;
}

TrialMeta getMeta(Subject subject, BaseAssessment config, int conditionIndex,
    int trialIndex) {
  return TrialMeta(
      subject.dob.toString(),
      subject.gender,
      subject.fall_history,
      config.type,
      config.conditionObtrusion[conditionIndex],
      config.conditionInstability[conditionIndex],
      conditionIndex,
      trialIndex);
}
