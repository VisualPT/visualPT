part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentEvent extends Equatable {}

class AssessmentInit extends AssessmentEvent {
  final bool reset;
  final Patient patient;
  AssessmentInit(this.patient, {this.reset = false});

  @override
  List<Object?> get props => [patient, reset];
}

class AssessmentBegin extends AssessmentEvent {
  final int index;
  AssessmentBegin(this.index);

  @override
  List<Object?> get props => [index];
}

class AssessmentIncrement extends AssessmentEvent {
  final Patient patient;
  final Segment segment;
  final int index;
  AssessmentIncrement(this.patient, this.segment, this.index);

  @override
  List<Object?> get props => [patient, segment, index];
}
