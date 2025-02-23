import 'dart:async';
import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart' show TemporalDateTime;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/core/services/api.dart';
import 'package:visualpt/features/assessment/types.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'assessment_event.dart';
part 'assessment_state.dart';

//Clean this up with a repository layer
class AssessmentBloc<T extends BaseAssessment>
    extends Bloc<AssessmentEvent, AssessmentState<T>> {
  final T meta;
  final Profile profile;
  late Assessment assessment;
  late Stage currentStage;
  DateTime assessmentStartTime = DateTime.now();
  DateTime stageStartTime = DateTime.now();

  bool storeData = true;

  AssessmentBloc(this.meta, this.profile) : super(AssessmentInputs<T>(meta)) {
    WakelockPlus.enable(); //Keep the screen on during the assessment
    on<AssessmentInit>(_onInit);
    on<AssessmentStage>(_onStage);
    on<AssessmentTrial>(_onTrial);
  }

  FutureOr<void> _onInit(
      AssessmentInit event, Emitter<AssessmentState> emit) async {
    try {
      print(event.formFields);
      assessmentStartTime = DateTime.now();
      assessment = Assessment(
        profile: profile,
        type: meta.type,
        duration: 0,
        extra: jsonEncode(event.formFields.map((k, v) => MapEntry(k, v.value))),
        createdAt: TemporalDateTime(DateTime.now()),
      );
      final asmtResponse = await ApiService.create(assessment);
      assessment = asmtResponse.data!;
      stageStartTime = DateTime.now();
      currentStage = Stage(
        assessment: assessment,
        duration: 0,
        stageNumber: assessment.stages?.length ?? 0,
      );
      final stageResponse = await ApiService.create(currentStage);
      currentStage = stageResponse.data!;
      emit(AssessmentActive<T>(
          getMeta(profile, meta, 0, 0), profile, event.storeData, this.meta));
    } catch (e) {
      emit(AssessmentError<T>(
          Exception("Error during initialization: $e"), meta));
      return;
    }
  }

  FutureOr<void> _onTrial(
      AssessmentTrial event, Emitter<AssessmentState> emit) async {
    try {
      // Update the latest stage with the new trial
      final response = await ApiService.create(Trial(
          startTime: event.startTime,
          duration: event.duration.inMilliseconds / 1000, //seconds
          detections: event.detections,
          stage: currentStage));
      final trial = response.data!;

      //Add the trial into the stage
      currentStage =
          currentStage.copyWith(trials: [...currentStage.trials ?? [], trial]);

      //If it's the last trial, we need to proceed to the next stage
      if (currentStage.trials?.length == meta.trials) {
        add(AssessmentStage());
      } else {
        //Otherwise, we just need to proceed to the next trial
        emit(AssessmentActive<T>(
            getMeta(
              profile,
              meta,
              assessment.stages!.length,
              currentStage.trials!.length,
            ),
            profile,
            storeData,
            meta));
      }
    } catch (e) {
      emit(AssessmentError<T>(
          Exception("Error while processing trial: $e"), meta));
      return;
    }
  }

  FutureOr<void> _onStage(
      AssessmentStage event, Emitter<AssessmentState> emit) async {
    emit(AssessmentLoading<T>(assessment.stages?.length ?? 0, meta));
    try {
      // the stage is done, lets update it
      currentStage =
          currentStage.copyWith(duration: getElapsedSeconds(stageStartTime));
      assessment = assessment
          .copyWith(stages: [...(assessment.stages ?? []), currentStage]);
      await ApiService.update(currentStage);

      //If it's the last stage, we need to end the assessment
      if (assessment.stages?.length == meta.stages) {
        final double assessmentDurationSeconds =
            getElapsedSeconds(assessmentStartTime);
        assessment = assessment.copyWith(
          duration: assessmentDurationSeconds,
        );
        await ApiService.update(assessment);
        emit(AssessmentAnalysis<T>(profile, storeData, assessment, meta));
      } else {
        //Otherwise, we need to proceed to the next stage
        stageStartTime = DateTime.now();
        currentStage = Stage(
          assessment: assessment,
          duration: 0,
          stageNumber: assessment.stages?.length ?? 0,
        );
        await ApiService.create(currentStage);
        emit(AssessmentActive<T>(
            getMeta(profile, meta, assessment.stages?.length ?? 0, 0),
            profile,
            storeData,
            meta));
      }
    } catch (e) {
      emit(AssessmentError<T>(
          Exception("Error while processing stage: $e"), meta));
      return;
    }
  }

  @override
  Future<void> close() async {
    WakelockPlus.disable();
    super.close();
    return;
  }
}

double getElapsedSeconds(DateTime start) {
  return DateTime.now().difference(start).inMilliseconds / 1000;
}

TrialMeta getMeta(Profile profile, BaseAssessment config, int conditionIndex,
    int trialIndex) {
  return TrialMeta(
      profile.dob.toString(),
      profile.gender,
      config.type,
      config.conditionObtrusion[conditionIndex],
      config.conditionInstability[conditionIndex],
      conditionIndex,
      trialIndex);
}
