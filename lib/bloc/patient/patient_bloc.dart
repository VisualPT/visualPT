import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/patient_service.dart';

part 'patient_event.dart';
part 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  late Patient currentPatient;
  PatientBloc() : super(const PatientNull()) {
    on<PatientSet>(_onSet);
  }

  FutureOr<void> _onSet(PatientSet event, Emitter<PatientState> emit) {
    final Patient patient = patientService.setPatientFromString(
        event.firstName, event.lastName, event.dob, event.gender, event.height);
    currentPatient = patient;
    patientService.savePatient(currentPatient);
    emit(PatientActive(patient: patient));
  }
}
