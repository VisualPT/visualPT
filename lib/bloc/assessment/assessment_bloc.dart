import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/assessments/_assessments.dart';

part 'assessment_event.dart';
part 'assessment_state.dart';

class AssessmentBloc extends Bloc<AssessmentEvent, AssessmentState> {
  final AssessmentType assessmentType;
  late int assessmentCount;

  final BuildContext context;
  late List<Widget Function(BuildContext)> introViews;
  late List<Widget Function(BuildContext)> captureViews;

  late List<File> assessmentAssets;
  late List<SkeletalSequence> skeletalSequences;

  late DateTime assessmentStart;
  late Duration assessmentDuration;
  late int index;

  AssessmentBloc(this.context, this.assessmentType)
      : super(AssessmentForm(assessmentType)) {
    on<AssessmentInit>(_onInit);
    on<AssessmentBegin>(_onBegin);
    on<AssessmentIncrement>(_onIncrement);

    assessmentStart = DateTime.now();
    index = 0;
    final assessmentRouter = AssessmentRouter(assessmentType);
    assessmentCount = assessmentRouter.assessmentCount;
    introViews = assessmentRouter.introWidgets;
    captureViews = assessmentRouter.captureWidgets;
  }

  FutureOr<void> _onInit(AssessmentInit event, Emitter<AssessmentState> emit) {
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
      assessmentDuration = assessmentStart.difference(DateTime.now());
      emit(AssessmentSuccess(assessmentAssets, index));
    } else {
      emit(AssessmentIntro(index));
    }
  }

  Widget getIntroView(BuildContext context, int index) =>
      introViews[index](context);

  Widget getCaptureView(BuildContext context, int index) =>
      captureViews[index](context);
}
