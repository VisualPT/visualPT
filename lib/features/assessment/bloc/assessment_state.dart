part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentState<T extends BaseAssessment> extends Equatable {
  final T config;
  final Map<String, FormFieldItem> formFields;
  const AssessmentState(this.config, this.formFields);
}

class AssessmentInputs<T extends BaseAssessment> extends AssessmentState<T> {
  const AssessmentInputs(super.config, super.formFields);
  @override
  List<Object?> get props => [config, formFields];
}

class AssessmentActive<T extends BaseAssessment> extends AssessmentState<T> {
  final TrialMeta meta;
  final Profile profile;
  const AssessmentActive(
      this.meta, this.profile, super.config, super.formFields);

  @override
  List<Object?> get props => [meta, profile, config, formFields];
}

class AssessmentAnalysis<T extends BaseAssessment> extends AssessmentState<T> {
  final Profile profile;
  final Assessment dbAssessment;
  const AssessmentAnalysis(
      this.profile, this.dbAssessment, super.config, super.formFields);

  @override
  List<Object?> get props => [profile, dbAssessment, config];
}

class AssessmentLoading<T extends BaseAssessment> extends AssessmentState<T> {
  final int index;
  const AssessmentLoading(this.index, super.config, super.formFields);
  @override
  List<Object?> get props => [index, config, formFields];
}

class AssessmentError<T extends BaseAssessment> extends AssessmentState<T> {
  //TODO Establish VisualPT Error Codes
  final Exception? message;

  const AssessmentError(this.message, super.config, super.formFields);

  @override
  List<Object?> get props => [message, config];
}
