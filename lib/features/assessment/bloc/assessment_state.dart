part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentState<T extends BaseAssessment> extends Equatable {
  final T assessment;
  const AssessmentState(this.assessment);
}

class AssessmentForm<T> extends AssessmentState {
  const AssessmentForm(super.assessment);
  @override
  List<Object?> get props => [];
}

class AssessmentActive<T> extends AssessmentState {
  final Patient patient;
  final int index;
  const AssessmentActive(this.patient, this.index, super.assessment);

  @override
  List<Object?> get props => [index, assessment];
}

class AssessmentAnalysis<T> extends AssessmentState {
  final Patient patient;
  final Assessment dbAssessment;
  const AssessmentAnalysis(this.patient, this.dbAssessment, super.assessment);

  @override
  List<Object?> get props => [assessment];
}

class AssessmentLoading<T> extends AssessmentState {
  const AssessmentLoading(super.assessment);
  @override
  List<Object?> get props => [assessment];
}

class AssessmentError<T> extends AssessmentState {
  //TODO Establish VisualPT Error Codes
  final Exception? message;

  const AssessmentError(this.message, super.assessment);

  @override
  List<Object?> get props => [message, assessment];
}
