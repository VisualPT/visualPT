import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/_service.dart';
import 'package:visualpt/service/user_service.dart';

class PatientService extends AppService {
  late Patient currentPatient;

  PatientService();

  Future<Patient> savePatientFromString(String first_name, String last_name,
      String dob, String gender, String height) async {
    Patient patient = Patient(
        first_name: first_name,
        last_name: last_name,
        dob: TemporalDate(DateTime.parse(dob)),
        gender: _PatientHelpers.genderParse(gender),
        height_in_inches: double.parse(height.split("\"")[0]),
        provider_contact: await UserService().currentUserEmail());

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
