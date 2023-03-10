import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/_service.dart';
import 'package:visualpt/service/user_service.dart';

PatientService patientService = PatientService();

class PatientService extends AppService {
  PatientService();

  Patient setPatientFromString(String firstName, String lastName, String dob,
      String gender, String height) {
    Patient patient = Patient(
      first_name: firstName,
      last_name: lastName,
      dob: TemporalDate(DateTime.parse(dob)),
      gender: _PatientHelpers.genderParse(gender),
      height_in_inches: double.parse(height.split("\"")[0]),
      provider_contact: currentUser.email,
    );
    saveData(patient);
    return patient;
  }

  Future<Patient> savePatient(Patient patient) async {
    saveData(patient);
    return patient;
  }
}

class _PatientHelpers {
  static Gender genderParse(String text) {
    switch (text) {
      case "MALE":
        return Gender.MALE;

      case "FEMALE":
        return Gender.FEMALE;

      default:
        return Gender.MALE;
    }
  }
}
