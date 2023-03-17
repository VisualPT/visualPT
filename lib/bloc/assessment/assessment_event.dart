part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentEvent {}

class AssessmentInit extends AssessmentEvent {
  final int index;
  final Patient patient;

  AssessmentInit(this.index, this.patient);
}

class AssessmentBegin extends AssessmentEvent {}

class AssessmentIncrement extends AssessmentEvent {
  AssessmentIncrement();
  //TODO add data that should be passed
}
