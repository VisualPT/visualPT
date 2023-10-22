part of 'assessment_bloc.dart';

@immutable
abstract class AssessmentEvent extends Equatable {
  final BuildContext context;
  const AssessmentEvent({required this.context});
}

class AssessmentInitial extends AssessmentEvent {
  final bool reset;
  final Patient patient;

  const AssessmentInitial({
    required this.patient,
    required super.context,
    this.reset = false,
  });

  @override
  List<Object?> get props => [patient, reset];
}

class AssessmentBegin extends AssessmentEvent {
  final int index;
  const AssessmentBegin({required this.index, required super.context});

  @override
  List<Object?> get props => [];
}

class AssessmentIncrement extends AssessmentEvent {
  final Patient patient;
  final Segment segment;
  final int index;
  const AssessmentIncrement(
      {required this.patient,
      required this.segment,
      required this.index,
      required super.context});

  @override
  List<Object?> get props => [patient, segment];
}
