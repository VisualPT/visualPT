import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/models/ModelProvider.dart';

class FormHelper {
  static Profile createProfile(
    String firstName,
    String lastName,
    String dateOfBirth,
    String gender,
    String height,
    String email,
  ) {
    return Profile(
      firstName: firstName,
      lastName: lastName,
      dob: TemporalDate(DateTime.parse(dateOfBirth)),
      gender: genderParse(gender),
      height: double.parse(height.split("\"")[0]),
      email: email,
    );
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

  static AssessmentType assessmentTypeParse(String part) {
    switch (part) {
      case "CTSIB":
        return AssessmentType.CTSIB;
      case "BERG":
        return AssessmentType.BERG;
      case "GAIT":
        return AssessmentType.GAIT;
      default:
        return AssessmentType.CTSIB;
    }
  }
}
