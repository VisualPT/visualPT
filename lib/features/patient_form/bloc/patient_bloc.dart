import 'dart:async';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/patient_form/service/patient_service.dart';

part 'patient_event.dart';
part 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  late PatientService _patientService;
  PatientBloc() : super(PatientInitial()) {
    _patientService = PatientService();
    on<PatientInit>(_onPatientInit);
    on<PatientClear>(_onPatientClear);
    on<PatientSaveFailure>(_onPatientSaveFailure);
  }

  FutureOr<void> _onPatientInit(
      PatientInit event, Emitter<PatientState> emit) async {
    try {
      //TODO Create a patient repository layer
      final patient = Patient(
          first_name: event.firstName,
          last_name: event.lastName,
          dob: TemporalDate(DateTime.parse(event.dateOfBirth)),
          gender: genderParse(event.gender),
          height_in_inches: double.parse(event.height.split("\"")[0]),
          provider_contact: event.email);
      _patientService.create(patient);

      emit(PatientSet(patient: patient));
    } on Exception catch (e) {
      emit(PatientError(message: e.toString()));
    }
  }

  FutureOr<void> _onPatientClear(
      PatientClear event, Emitter<PatientState> emit) async {
    emit(PatientInitial());
  }

  FutureOr<void> _onPatientSaveFailure(
      PatientSaveFailure event, Emitter<PatientState> emit) {
    emit(PatientError(message: event.message));
  }
}

Gender genderParse(String text) {
  switch (text) {
    case "MALE":
      return Gender.MALE;

    case "FEMALE":
      return Gender.FEMALE;

    default:
      return Gender.MALE;
  }
}
