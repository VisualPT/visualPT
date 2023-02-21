part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentEvent {}

class AssessmentInit extends AssessmentEvent {
  final int index;

  AssessmentInit(this.index);
}

class AssessmentBegin extends AssessmentEvent {}

class AssessmentIncrement extends AssessmentEvent {
  final File assessmentData;

  AssessmentIncrement(this.assessmentData);
}
