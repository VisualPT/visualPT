import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/models/Gender.dart';
import 'package:visualpt/models/Patient.dart';

class FormHelper {
  static Patient createPatient(String firstName, String lastName,
      String dateOfBirth, String gender, String height, String email) {
    return Patient(
        first_name: firstName,
        last_name: lastName,
        dob: TemporalDate(DateTime.parse(dateOfBirth)),
        gender: FormHelper.genderParse(gender),
        height_in_inches: double.parse(height.split("\"")[0]),
        provider_contact: email);
  }

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
