part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentState {}

class AssessmentForm extends AssessmentState {
  final AssessmentType assessmentType;
  AssessmentForm(this.assessmentType);
}

class AssessmentIntro extends AssessmentState {
  final int index;
  final Widget Function(BuildContext context) getView;
  AssessmentIntro(this.index, this.getView);
}

class AssessmentActive extends AssessmentState {
  final int index;
  final Widget Function(BuildContext context) getView;
  AssessmentActive(this.index, this.getView);
}

class AssessmentAnalysis extends AssessmentState {
  final Widget Function(BuildContext context) getView;
  AssessmentAnalysis(this.getView);
}

class AssessmentLoading extends AssessmentState {}

class AssessmentError extends AssessmentState {
  //TODO Establish VisualPT Error Codes
  final Exception? message;

  AssessmentError({this.message});
}
