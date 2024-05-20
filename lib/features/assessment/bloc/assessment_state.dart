part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentState<T> extends Equatable {
  final T assessment;
  const AssessmentState(this.assessment);
}

class AssessmentForm<T> extends AssessmentState<T> {
  const AssessmentForm(super.assessment);
  @override
  List<Object?> get props => [];
}

class AssessmentActive<T> extends AssessmentState<T> {
  final ClinicalMeta meta;
  final Subject subject;
  final int condition;
  final int trial;
  final bool storeData;
  const AssessmentActive(this.meta, this.subject, this.condition, this.trial,
      this.storeData, super.assessment);

  @override
  List<Object?> get props => [assessment, condition, trial, storeData];
}

class AssessmentAnalysis<T> extends AssessmentState<T> {
  final Subject subject;
  final bool storeData;
  final Assessment dbAssessment;
  const AssessmentAnalysis(
      this.subject, this.storeData, this.dbAssessment, super.assessment);

  @override
  List<Object?> get props => [assessment];
}

class AssessmentLoading<T> extends AssessmentState<T> {
  final int index;
  const AssessmentLoading(super.assessment, this.index);
  @override
  List<Object?> get props => [assessment, index];
}

class AssessmentError<T> extends AssessmentState<T> {
  //TODO Establish VisualPT Error Codes
  final Exception? message;

  const AssessmentError(this.message, super.assessment);

  @override
  List<Object?> get props => [message, assessment];
}
