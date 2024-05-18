part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentEvent extends Equatable {}

class AssessmentInit extends AssessmentEvent {
  final Subject subject;
  final bool storeData;
  final bool reset;
  AssessmentInit(this.subject, this.storeData, {this.reset = false});

  @override
  List<Object?> get props => [subject, reset];
}

class AssessmentIncrement extends AssessmentEvent {
  final Condition condition;
  AssessmentIncrement(this.condition);

  @override
  List<Object?> get props => [condition];
}
