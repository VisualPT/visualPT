part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentEvent extends Equatable {}

class AssessmentInit extends AssessmentEvent {
  final Subject subject;
  AssessmentInit(this.subject);

  @override
  List<Object?> get props => [subject];
}

class AssessmentCondition extends AssessmentEvent {
  AssessmentCondition();

  @override
  List<Object?> get props => [];
}

class AssessmentTrial extends AssessmentEvent {
  final Duration duration;
  final amplify.TemporalDateTime startTime;
  final List<Detection>? detections;
  AssessmentTrial(this.detections, this.startTime, this.duration);

  @override
  List<Object?> get props => [duration, detections];
}
