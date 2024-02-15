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
  final Patient patient;
  final bool storeData;
  final Segment segment;
  final int index;
  AssessmentIncrement(this.patient, this.storeData, this.segment, this.index);

  @override
  List<Object?> get props => [patient, segment, index];
}
