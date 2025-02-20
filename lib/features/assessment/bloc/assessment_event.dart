part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentEvent extends Equatable {}

class AssessmentInit extends AssessmentEvent {
  AssessmentInit(this.formFields, this.storeData);
  final Map<String, FormFieldItem> formFields;
  final bool storeData;

  @override
  List<Object?> get props => [formFields, storeData];
}

class AssessmentStage extends AssessmentEvent {
  AssessmentStage();

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
