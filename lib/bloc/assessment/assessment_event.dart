part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentEvent {}

class AssessmentInit extends AssessmentEvent {}

class AssessmentBegin extends AssessmentEvent {}

class AssessmentIncrement extends AssessmentEvent {
  final File assessmentData;

  AssessmentIncrement(this.assessmentData);
}

class AssessmentFinish extends AssessmentEvent {}
