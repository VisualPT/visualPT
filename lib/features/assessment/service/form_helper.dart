import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/models/ModelProvider.dart';

class FormHelper {
  static Subject createSubject(
      String userID,
      String firstName,
      String lastName,
      String dateOfBirth,
      String gender,
      String height,
      String email,
      String fallHistory) {
    return Subject(
        userID: userID,
        first_name: firstName,
        last_name: lastName,
        dob: TemporalDate(DateTime.parse(dateOfBirth)),
        gender: FormHelper.genderParse(gender),
        height_in_inches: double.parse(height.split("\"")[0]),
        provider_contact: email,
        fall_history: FormHelper.fallHistoryParse(fallHistory));
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

  static FallHistory fallHistoryParse(String text) {
    switch (text) {
      case "NONE":
        return FallHistory.NONE;
      case "FEW":
        return FallHistory.FEW;
      case "RECURRENT":
        return FallHistory.RECURRENT;
      default:
        return FallHistory.NONE;
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
