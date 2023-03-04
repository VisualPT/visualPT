import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/patient_service.dart';

part 'patient_event.dart';
part 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  late Patient currentPatient;
  PatientBloc() : super(const PatientNull()) {
    on<PatientUpdate>(_onUpdate);
  }

  FutureOr<void> _onUpdate(
      PatientUpdate event, Emitter<PatientState> emit) async {
    final Patient patient = await PatientService().savePatientFromString(
        event.firstName, event.lastName, event.dob, event.gender, event.height);
    currentPatient = patient;
    await Amplify.DataStore.save(patient);
    emit(PatientActive(patient: patient));
  }
}
