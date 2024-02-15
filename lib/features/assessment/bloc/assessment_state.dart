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
  final Patient patient;
  final bool storeData;
  final int index;
  const AssessmentActive(
      this.patient, this.storeData, this.index, super.assessment);

  @override
  List<Object?> get props => [index, assessment];
}

class AssessmentAnalysis<T> extends AssessmentState<T> {
  final Patient patient;
  final bool storeData;
  final Assessment dbAssessment;
  const AssessmentAnalysis(
      this.patient, this.storeData, this.dbAssessment, super.assessment);

  @override
  List<Object?> get props => [assessment];
}

class AssessmentLoading<T> extends AssessmentState<T> {
  const AssessmentLoading(super.assessment);
  @override
  List<Object?> get props => [assessment];
}

class AssessmentError<T> extends AssessmentState<T> {
  //TODO Establish VisualPT Error Codes
  final Exception? message;

  const AssessmentError(this.message, super.assessment);

  @override
  List<Object?> get props => [message, assessment];
}
