import 'dart:async';
import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart' show TemporalDateTime;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/core/services/api.dart';
import 'package:visualpt/features/assessment/types.dart';
import 'package:visualpt/features/capture/service/pose_landmarks.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'assessment_event.dart';
part 'assessment_state.dart';

//Clean this up with a repository layer
class AssessmentBloc<T extends BaseAssessment>
    extends Bloc<AssessmentEvent, AssessmentState<T>> {
  final T config;
  final Profile profile;
  late Assessment assessment;
  late Stage currentStage;
  DateTime assessmentStartTime = DateTime.now();
  DateTime stageStartTime = DateTime.now();

  bool storeData = true;

  AssessmentBloc(this.config, this.profile)
      : super(AssessmentInputs<T>(config, config.formFields)) {
    WakelockPlus.enable(); //Keep the screen on during the assessment
    on<AssessmentInit>(_onInit);
    on<AssessmentStage>(_onStage);
    on<AssessmentTrial>(_onTrial);
  }

  FutureOr<void> _onInit(
      AssessmentInit event, Emitter<AssessmentState> emit) async {
    try {
      emit(AssessmentLoading<T>(0, config, event.formFields));
      final validatedFields = fillInBlankFields(event.formFields, config);
      storeData = bool.tryParse(validatedFields['store data']?.value) ?? true;
      assessmentStartTime = DateTime.now();
      final extra = jsonEncode(Map.fromEntries(validatedFields.entries
          .map((entry) => MapEntry(entry.key, entry.value.value.toString()))));
      assessment = Assessment(
        profile: profile,
        type: config.type,
        duration: 0,
        extra: extra,
        createdAt: TemporalDateTime(DateTime.now()),
      );
      //TODO: dont save this till the end of the assessment to ensure we have some data in it?
      if (storeData) {
        final asmtResponse = await ApiService.create(assessment);
        assessment = asmtResponse.data!;
      }
      stageStartTime = DateTime.now();
      currentStage = Stage(
        assessment: assessment,
        duration: 0,
        stageNumber: assessment.stages?.length ?? 0,
      );
      if (storeData) {
        final stageResponse = await ApiService.create(currentStage);
        currentStage = stageResponse.data!;
      }

//Set the meta based on fields and possible overrides
      final defaultMeta = getMeta(config, profile, validatedFields, 0, 0);
      emit(AssessmentActive<T>(defaultMeta, profile, config, validatedFields));
    } catch (e) {
      emit(AssessmentError<T>(
          Exception(
              "Error during initialization: $e on assessment ${config.name} with form fields ${event.formFields}"),
          config,
          event.formFields));
      return;
    }
  }

  FutureOr<void> _onTrial(
      AssessmentTrial event, Emitter<AssessmentState> emit) async {
    try {
      emit(AssessmentLoading<T>(
          assessment.stages?.length ?? 0, config, event.formFields));
      // Update the latest stage with the new trial

      var trial = Trial(
          startTime: event.startTime,
          duration: event.duration.inMilliseconds / 1000, //seconds
          compressedDetections:
              PoseLandmarks.encodeCompressed(event.detections ?? []),
          stage: currentStage);

      if (storeData) {
        final response = await ApiService.create(trial);
        trial = response.data!;
      }
      //Add the trial into the stage
      currentStage =
          currentStage.copyWith(trials: [...currentStage.trials ?? [], trial]);

      final meta = getMeta(
        config,
        profile,
        event.formFields,
        assessment.stages?.length ?? 0,
        currentStage.trials?.length ?? 0,
      );

      //If it's the last trial, we need to proceed to the next stage
      if (currentStage.trials?.length == meta.trials) {
        add(AssessmentStage(event.formFields));
      } else {
        //Otherwise, we just need to proceed to the next trial
        emit(
          AssessmentActive<T>(meta, profile, config, event.formFields),
        );
      }
    } catch (e, stack) {
      emit(AssessmentError<T>(
          Exception("Error while processing trial: $e, $stack"),
          config,
          event.formFields));
      return;
    }
  }

  FutureOr<void> _onStage(
      AssessmentStage event, Emitter<AssessmentState> emit) async {
    emit(AssessmentLoading<T>(
        assessment.stages?.length ?? 0, config, event.formFields));
    try {
      // the stage is done, lets update it
      currentStage =
          currentStage.copyWith(duration: getElapsedSeconds(stageStartTime));
      assessment = assessment
          .copyWith(stages: [...(assessment.stages ?? []), currentStage]);
      if (storeData) {
        await ApiService.update(currentStage);
      }

      //If it's the last stage, we need to end the assessment
      if (assessment.stages?.length == config.stages) {
        final double assessmentDurationSeconds =
            getElapsedSeconds(assessmentStartTime);
        assessment = assessment.copyWith(
          duration: assessmentDurationSeconds,
        );
        if (storeData) {
          await ApiService.update(assessment);
        }
        emit(AssessmentAnalysis<T>(
            profile, assessment, config, event.formFields));
      } else {
        //Otherwise, we need to proceed to the next stage
        stageStartTime = DateTime.now();
        currentStage = Stage(
          assessment: assessment,
          duration: 0,
          stageNumber: assessment.stages?.length ?? 0,
        );
        if (storeData) {
          await ApiService.create(currentStage);
        }
        emit(AssessmentActive<T>(
            getMeta(config, profile, event.formFields,
                assessment.stages?.length ?? 0, 0),
            profile,
            config,
            event.formFields));
      }
    } catch (e) {
      emit(AssessmentError<T>(Exception("Error while processing stage: $e"),
          config, event.formFields));
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
