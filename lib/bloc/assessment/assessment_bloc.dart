import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpers/helpers.dart';
import 'package:visualpt/bloc/camera/camera_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';

part 'assessment_event.dart';
part 'assessment_state.dart';

class AssessmentBloc extends Bloc<AssessmentEvent, AssessmentState> {
  final AssessmentType assessmentType;
  final List<Widget> assessmentViews;
  late List<File> assessmentAssets;
  late List<SkeletalSequence> skeletalSequence;
  final DateTime assessmentStart = DateTime.now();
  late DateTime assessmentEnd;
  late int index;

  AssessmentBloc(this.assessmentType, this.assessmentViews)
      : super(AssessmentIntro(assessmentViews[0], 0)) {
    on<AssessmentInit>((event, emit) {});
    on<AssessmentBegin>((event, emit) {
      // TODO: implement event handler
    });
    on<AssessmentIncrement>((event, emit) {
      // TODO: implement event handler
    });
    on<AssessmentFinish>((event, emit) {
      // TODO: implement event handler
    });
  }

  //Store persistent bloc data
  void load() {
    index = 0;
  }
}
