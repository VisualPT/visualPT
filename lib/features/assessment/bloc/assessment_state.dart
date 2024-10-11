part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentState<T> extends Equatable {
  final T meta;
  const AssessmentState(this.meta);
}

class AssessmentForm<T> extends AssessmentState<T> {
  const AssessmentForm(super.meta);
  @override
  List<Object?> get props => [meta];
}

class AssessmentActive<T> extends AssessmentState<T> {
  final TrialMeta trialMeta;
  final Subject subject;
  final bool storeData;
  const AssessmentActive(
      this.trialMeta, this.subject, this.storeData, super.meta);

  @override
  List<Object?> get props => [trialMeta, meta, storeData];
}

class AssessmentAnalysis<T> extends AssessmentState<T> {
  final Subject subject;
  final bool storeData;
  final Assessment dbAssessment;
  const AssessmentAnalysis(
      this.subject, this.storeData, this.dbAssessment, super.meta);

  @override
  List<Object?> get props => [subject, storeData, dbAssessment, meta];
}

class AssessmentLoading<T> extends AssessmentState<T> {
  final int index;
  const AssessmentLoading(this.index, super.meta);
  @override
  List<Object?> get props => [meta, index];
}

class AssessmentError<T> extends AssessmentState<T> {
  //TODO Establish VisualPT Error Codes
  final Exception? message;

  const AssessmentError(this.message, super.meta);

  @override
  List<Object?> get props => [message, meta];
}
