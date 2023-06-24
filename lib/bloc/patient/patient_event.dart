part of 'patient_bloc.dart';

abstract class PatientEvent extends Equatable {
  const PatientEvent();

  @override
  List<Object> get props => [];
}

class PatientInit extends PatientEvent {
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String gender;
  final String height;
  final String email;

  const PatientInit(
      {required this.firstName,
      required this.lastName,
      required this.dateOfBirth,
      required this.gender,
      required this.height,
      required this.email});

  @override
  List<Object> get props =>
      [firstName, lastName, dateOfBirth, gender, height, email];
}

class PatientClear extends PatientEvent {
  const PatientClear();
}

class PatientSaveFailure extends PatientEvent {
  final String message;

  const PatientSaveFailure({required this.message});

  @override
  List<Object> get props => [message];
}
