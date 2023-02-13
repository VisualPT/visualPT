part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentState {}

class AssessmentForm extends AssessmentState {
  final AssessmentType assessmentType;
  AssessmentForm(this.assessmentType);
}

class AssessmentIntro extends AssessmentState {
  final int index;

  AssessmentIntro(this.index);
}

class AssessmentActive extends AssessmentState {
  final int index;

  AssessmentActive(this.index);
}

class AssessmentSuccess extends AssessmentState {
  final List<File> assessmentAssets;
  final int index;

  AssessmentSuccess(this.assessmentAssets, this.index);
}

class AssessmentError extends AssessmentState {
  //TODO Establish VisualPT Error Codes
  final Exception e;

  AssessmentError(this.e);
}
