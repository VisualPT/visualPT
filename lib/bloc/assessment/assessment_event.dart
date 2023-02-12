part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentEvent {}

class AssessmentIntroduce extends AssessmentEvent {}

class AssessmentBegin extends AssessmentEvent {}

class AssessmentIncrement extends AssessmentEvent {}

class AssessmentFinish extends AssessmentEvent {}