import 'package:amplify_flutter/amplify_flutter.dart';

int getAge(TemporalDate dob) {
  //Converts an Amplify TemporalDate to a difference in time by years and returns that as an int
  final now = TemporalDate.now();
  return now.getDateTime().year - dob.getDateTime().year;
}
