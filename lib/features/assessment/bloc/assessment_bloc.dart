import 'dart:async';
import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart' as amplify;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  Stage? currentStage;
  DateTime assessmentStartTime = DateTime.now();
  DateTime conditionStartTime = DateTime.now();

  bool storeData = true;

  AssessmentBloc(this.meta, this.profile) : super(AssessmentInputs<T>(meta)) {
    WakelockPlus.enable(); //Keep the screen on during the assessment
    on<AssessmentInit>(_onInit);
    on<AssessmentStage>(_onStage);
    on<AssessmentTrial>(_onTrial);
  }

  FutureOr<void> _onInit(
      AssessmentInit event, Emitter<AssessmentState> emit) async {
    assessmentStartTime = DateTime.now();
    assessment = Assessment(
        profile: profile,
        type: meta.type,
        duration: 0,
        datetime: amplify.TemporalDateTime(DateTime.now()),
        extra: jsonEncode(event.formFields
            .map((key, value) => MapEntry(key, value.controller.text))));

    final response = await amplify.Amplify.API
        .mutate(request: ModelMutations.create(assessment))
        .response;

    if (response.hasErrors || response.data == null) {
      emit(AssessmentError<T>(
          Exception("Error while saving the assessment: ${response.errors}"),
          meta));
      return;
    }

    assessment = response.data!;

    conditionStartTime = DateTime.now();

    emit(AssessmentActive<T>(
        getMeta(profile, meta, 0, 0), profile, event.storeData, this.meta));
  }

  FutureOr<void> _onStage(
      AssessmentStage event, Emitter<AssessmentState> emit) async {
    emit(AssessmentLoading<T>(assessment.stages?.length ?? 0, meta));
    //FIXME: EEEEEE
    currentStage ??= Stage(
      assessment: assessment,
      duration: 0,
      stageNumber: assessment.stages?.length ?? 0,
    );
    assessment = assessment
        .copyWith(stages: [...assessment.stages ?? [], currentStage!]);
    currentStage = (await amplify.Amplify.API
            .mutate(
                request: ModelMutations.update(currentStage!
                    .copyWith(duration: getElapsedSeconds(conditionStartTime))))
            .response)
        .data;

    final newStages =
        List<Stage>.from([...(assessment.stages ?? []), currentStage]);
    //Reset the current stage object
    currentStage = (await amplify.Amplify.API
            .mutate(
                request: ModelMutations.create(Stage(
              assessment: assessment,
              duration: 0,
              stageNumber: newStages.length - 1,
            )))
            .response)
        .data;

    if (assessment.stages?.length == meta.stages) {
      final double assessmentDurationSeconds =
          getElapsedSeconds(assessmentStartTime);
      assessment = (await amplify.Amplify.API
              .mutate(
                  request: ModelMutations.update(assessment.copyWith(
                duration: assessmentDurationSeconds,
                datetime: amplify.TemporalDateTime(DateTime.now()),
              )))
              .response)
          .data!;

      emit(AssessmentAnalysis<T>(profile, storeData, assessment, meta));
    } else {
      conditionStartTime = DateTime.now();
      emit(AssessmentActive<T>(
          getMeta(profile, meta, assessment.stages?.length ?? 0, 0),
          profile,
          storeData,
          meta));
    }
  }

  FutureOr<void> _onTrial(
      AssessmentTrial event, Emitter<AssessmentState> emit) async {
    if (currentStage == null) {
      //TODO: Implement retryability and error handling
      emit(AssessmentError<T>(Exception("No current stage found"), meta));
      return;
    }

    // Update the latest stage with the new trial
    final response = await amplify.Amplify.API
        .mutate(
            request: ModelMutations.create(Trial(
                id: amplify.UUID().toString(),
                startTime: event.startTime,
                duration: event.duration.inMilliseconds / 1000, //seconds
                detections: event.detections,
                stage: currentStage)))
        .response;

    if (response.hasErrors || response.data == null) {
      print(response.errors);
      emit(AssessmentError<T>(
          Exception("Error while saving the trial: ${response.errors}"), meta));
      return;
    }

    final trial = response.data!;

    currentStage = currentStage == null
        ? Stage(
            assessment: assessment,
            duration: 0,
            stageNumber: assessment.stages?.length ?? 0,
            trials: [trial])
        : currentStage
            ?.copyWith(trials: [...currentStage?.trials ?? [], trial]);

    //Check if its the last trial
    if (currentStage?.trials?.length == meta.trials) {
      currentStage = currentStage?.copyWith(
          duration: getElapsedSeconds(conditionStartTime));
      final List<Stage> allStages = [
        ...(assessment.stages ?? []),
        currentStage!
      ];
      assessment = assessment.copyWith(stages: allStages);
      add(AssessmentStage());
      return;
    }

    //If it is not, then we need to proceed to the next trial

    // Prepare the next trial state here
    emit(AssessmentActive<T>(
        getMeta(
          profile,
          meta,
          assessment.stages?.length ?? 0,
          currentStage?.trials?.length ?? 0,
        ),
        profile,
        storeData,
        meta));
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
