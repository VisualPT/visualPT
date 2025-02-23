part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentState<T extends BaseAssessment> extends Equatable {
  final T meta;
  const AssessmentState(this.meta);
}

class AssessmentInputs<T extends BaseAssessment> extends AssessmentState<T> {
  const AssessmentInputs(super.meta);
  @override
  List<Object?> get props => [meta];
}

class AssessmentActive<T extends BaseAssessment> extends AssessmentState<T> {
  final TrialMeta trialMeta;
  final Profile profile;
  final bool storeData;
  const AssessmentActive(
      this.trialMeta, this.profile, this.storeData, super.meta);

  @override
  List<Object?> get props => [trialMeta, profile, storeData, meta];
}

class AssessmentAnalysis<T extends BaseAssessment> extends AssessmentState<T> {
  final Profile profile;
  final bool storeData;
  final Assessment dbAssessment;
  const AssessmentAnalysis(
      this.profile, this.storeData, this.dbAssessment, super.meta);

  @override
  List<Object?> get props => [profile, storeData, dbAssessment, meta];
}

class AssessmentLoading<T extends BaseAssessment> extends AssessmentState<T> {
  final int index;
  const AssessmentLoading(this.index, super.meta);
  @override
  List<Object?> get props => [meta, index];
}

class AssessmentError<T extends BaseAssessment> extends AssessmentState<T> {
  //TODO Establish VisualPT Error Codes
  final Exception? message;

  const AssessmentError(this.message, super.meta);

  @override
  List<Object?> get props => [message, meta];
}
