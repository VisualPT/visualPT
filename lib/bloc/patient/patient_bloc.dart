import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/patient_service.dart';

part 'patient_event.dart';
part 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  late PatientService _patientService;
  PatientBloc() : super(PatientInitial()) {
    _patientService = PatientService();
    on<PatientInit>(_onPatientInit);
    on<PatientClear>(_onPatientClear);
  }

  FutureOr<void> _onPatientInit(
      PatientInit event, Emitter<PatientState> emit) async {
    try {
      final patient = await _patientService.create(
          firstName: event.firstName,
          lastName: event.lastName,
          dob: event.dateOfBirth,
          gender: event.gender,
          height: event.height,
          email: event.email);

      emit(PatientSet(patient: patient));
    } on Exception catch (e) {
      emit(PatientError(message: e.toString()));
    }
  }

  FutureOr<void> _onPatientClear(
      PatientClear event, Emitter<PatientState> emit) async {
    emit(PatientInitial());
  }
}
