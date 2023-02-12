import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'assessment_event.dart';
part 'assessment_state.dart';

class AssessmentBloc extends Bloc<AssessmentEvent, AssessmentState> {
  late List<File> assessmentAssets;
  AssessmentBloc() : super(AssessmentTutorial()) {
    on<AssessmentEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
