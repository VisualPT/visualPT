part of 'patient_bloc.dart';

abstract class PatientState extends Equatable {
  const PatientState();

  @override
  List<Object> get props => [];
}

class PatientNull extends PatientState {
  const PatientNull();
}

class PatientActive extends PatientState {
  final Patient patient;
  const PatientActive({required this.patient});

  @override
  List<Object> get props => [];
}
