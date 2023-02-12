part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentState {}

class AssessmentTutorial extends AssessmentState {}

class AssessmentActive extends AssessmentState {}

class AssessmentPaused extends AssessmentState {}

class AssessmentAborted extends AssessmentState {}

class AssessmentSuccess extends AssessmentState {}

class AssessmentError extends AssessmentState {
  final String = "hello";
}
