part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentEvent extends Equatable {}

class AssessmentInit extends AssessmentEvent {
  final Patient patient;
  final bool storeData;
  final bool reset;
  AssessmentInit(this.patient, this.storeData, {this.reset = false});

  @override
  List<Object?> get props => [patient, reset];
}

class AssessmentIncrement extends AssessmentEvent {
  final Segment segment;
  AssessmentIncrement(this.segment);

  @override
  List<Object?> get props => [segment];
}
