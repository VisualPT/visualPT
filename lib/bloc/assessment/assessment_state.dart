part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentState extends Equatable {}

class AssessmentIntro extends AssessmentState {
  final int index;
  final Widget Function(BuildContext context) getView;
  AssessmentIntro(this.index, this.getView);

  @override
  List<Object?> get props => [index, getView];
}

class AssessmentActive extends AssessmentState {
  final int index;
  final Widget Function(BuildContext context) getView;
  AssessmentActive(this.index, this.getView);

  @override
  List<Object?> get props => [index, getView];
}

class AssessmentAnalysis extends AssessmentState {
  final Widget Function(BuildContext context) getView;
  AssessmentAnalysis(this.getView);

  @override
  List<Object?> get props => [getView];
}

class AssessmentLoading extends AssessmentState {
  @override
  List<Object?> get props => [];
}

class AssessmentError extends AssessmentState {
  //TODO Establish VisualPT Error Codes
  final Exception? message;

  AssessmentError({this.message});

  @override
  List<Object?> get props => [message];
}
