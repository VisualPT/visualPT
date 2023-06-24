import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/_service.dart';

PatientService patientService = PatientService();

class PatientService extends AppService {
  PatientService();

  Future<Patient> create(
      {required String firstName,
      required String lastName,
      required String dob,
      required String gender,
      required String height,
      required String email}) async {
    Patient patient = Patient(
      first_name: firstName,
      last_name: lastName,
      dob: TemporalDate(DateTime.parse(dob)),
      gender: _PatientHelpers.genderParse(gender),
      height_in_inches: double.parse(height.split("\"")[0]),
      provider_contact: email,
    );
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
