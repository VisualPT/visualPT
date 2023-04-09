part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentEvent {
  final BuildContext context;
  const AssessmentEvent({required this.context});
}

class AssessmentInit extends AssessmentEvent {
  final bool reset;
  final Patient patient;

  const AssessmentInit({
    required this.reset,
    required this.patient,
    required super.context,
  });
}

class AssessmentBegin extends AssessmentEvent {
  const AssessmentBegin({required super.context});
}

class AssessmentIncrement extends AssessmentEvent {
  final Patient patient;
  final Segment segment;
  const AssessmentIncrement(
      {required this.patient, required this.segment, required super.context});
}
