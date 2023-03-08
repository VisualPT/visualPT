import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/assessment_service.dart';
import 'package:visualpt/views/analysis_view.dart';
import 'package:visualpt/views/assessments/_assessments.dart';

part 'assessment_event.dart';
part 'assessment_state.dart';

class AssessmentBloc extends Bloc<AssessmentEvent, AssessmentState> {
  final BuildContext context;
  final AssessmentType assessmentType;

  late Assessment assessment;
  late AssessmentRouter assessmentRouter;
  late int assessmentCount;
  late List<Widget Function(BuildContext, String)> introViews;
  late List<Widget Function(BuildContext, String)> captureViews;
  late List<File> assessmentAssets = [];
  late List<SkeletalSequence> skeletalSequences = [];
  late DateTime assessmentStart;
  late int assessmentDurationSeconds; //TODO store this in Amplify
  late int index;

  AssessmentBloc(this.context, this.assessmentType)
      : super(AssessmentForm(assessmentType)) {
    on<AssessmentInit>(_onInit);
    on<AssessmentBegin>(_onBegin);
    on<AssessmentIncrement>(_onIncrement);

    assessmentStart = DateTime.now();
    assessmentRouter = AssessmentRouter(assessmentType);
    assessmentCount = assessmentRouter.assessmentCount;
    introViews = assessmentRouter.introWidgets;
    captureViews = assessmentRouter.captureWidgets;
    index = 0;
  }

  FutureOr<void> _onInit(AssessmentInit event, Emitter<AssessmentState> emit) {
    //TODO transition visual
    ///Creates the assessment instance when the sequence first begins
    event.index == 0
        ? assessment = AssessmentService()
            .createAssessment(assessmentType, DateTime.now(), event.patient.id)
        : null;
    emit(AssessmentIntro(index));
  }

  FutureOr<void> _onBegin(
      AssessmentBegin event, Emitter<AssessmentState> emit) {
    emit(AssessmentActive(index));
  }

  FutureOr<void> _onIncrement(
      AssessmentIncrement event, Emitter<AssessmentState> emit) {
    assessmentAssets.add(event.assessmentData);
    index++;
    if (index == assessmentCount) {
      assessmentDurationSeconds =
          DateTime.now().difference(assessmentStart).inSeconds;
      log("Time elapsed: $assessmentDurationSeconds seconds \nassests $assessmentAssets");

      emit(AssessmentSuccess(assessmentAssets, index));
    } else {
      emit(AssessmentIntro(index));
    }
  }

  Widget getIntroView(BuildContext context, String assessmentName, int index) =>
      introViews[index](context, assessmentName);

  Widget getCaptureView(
          BuildContext context, String assessmentName, int index) =>
      captureViews[index](context, assessmentName);

  Widget getAnalysisView(
    BuildContext context,
    Patient patient,
  ) =>
      AnalysisView(
          patient: patient,
          assessment: assessment,
          assessmentAssets: assessmentAssets);
}

void saveCameraDataToAssessment(
    BuildContext context, AssessmentBloc assessment, CameraBloc camera) {
  camera.add(CameraStop());
  camera.getData().then((data) => assessment.add(AssessmentIncrement(data)));
}
