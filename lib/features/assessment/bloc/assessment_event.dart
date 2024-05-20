part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentEvent extends Equatable {}

class AssessmentInit extends AssessmentEvent {
  final Subject subject;
  final bool reset;
  AssessmentInit(this.subject, {this.reset = false});

  @override
  List<Object?> get props => [subject, reset];
}

class AssessmentCondition extends AssessmentEvent {
  final Condition condition;
  AssessmentCondition(this.condition);

  @override
  List<Object?> get props => [condition];
}

class AssessmentTrial extends AssessmentEvent {
  final Trial trial;
  AssessmentTrial(this.trial);

  @override
  List<Object?> get props => [trial];
}
