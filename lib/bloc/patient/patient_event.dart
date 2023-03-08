part of 'patient_bloc.dart';

abstract class PatientEvent extends Equatable {
  const PatientEvent();

  @override
  List<Object> get props => [];
}

class PatientSet extends PatientEvent {
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;
  final String height;
  const PatientSet(
      this.firstName, this.lastName, this.dob, this.gender, this.height);

  @override
  List<Object> get props => [];
}
