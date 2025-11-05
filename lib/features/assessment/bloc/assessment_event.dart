part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentEvent extends Equatable {
  final Map<String, FormFieldItem> formFields;
  const AssessmentEvent(this.formFields);
  @override
  List<Object?> get props => [formFields];
}

class AssessmentInit extends AssessmentEvent {
  const AssessmentInit(super.formFields);

  @override
  List<Object?> get props => [formFields];
}

class AssessmentStage extends AssessmentEvent {
  const AssessmentStage(super.formFields);

  @override
  List<Object?> get props => [formFields];
}

class AssessmentTrial extends AssessmentEvent {
  final Duration duration;
  final TemporalDateTime startTime;
  final List<Detection>? detections;
  const AssessmentTrial(
      this.detections, this.startTime, this.duration, super.formFields);

  @override
  List<Object?> get props => [duration, detections, startTime];
}
