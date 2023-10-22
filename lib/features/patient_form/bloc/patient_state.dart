part of 'patient_bloc.dart';

abstract class PatientState extends Equatable {
  const PatientState();

  @override
  List<Object> get props => [];
}

class PatientInitial extends PatientState {}

class PatientSet extends PatientState {
  final Patient patient;

  const PatientSet({required this.patient});

  @override
  List<Object> get props => [patient];
}

class PatientError extends PatientState {
  final String message;

  const PatientError({required this.message});

  @override
  List<Object> get props => [message];
}
