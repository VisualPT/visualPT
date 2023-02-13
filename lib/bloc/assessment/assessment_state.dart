part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentState {}

class AssessmentForm extends AssessmentState {
  final Widget assessmentView;
  final int index;
  final AssessmentType assessmentType;

  AssessmentForm(this.assessmentView, this.index, this.assessmentType);
}

class AssessmentIntro extends AssessmentState {
  final Widget assessmentView;
  final int index;

  AssessmentIntro(this.assessmentView, this.index);
}

class AssessmentActive extends AssessmentState {
  final Widget assessmentView;
  final int index;

  AssessmentActive(this.assessmentView, this.index);
}

class AssessmentSuccess extends AssessmentState {
  final Widget assessmentView;
  final List<File> assessmentAssets;
  final int index;

  AssessmentSuccess(this.assessmentView, this.assessmentAssets, this.index);
}

class AssessmentError extends AssessmentState {
  //TODO Establish VisualPT Error Codes
  final Exception e;

  AssessmentError(this.e);
}
