import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/models/ModelProvider.dart';

class Gait {
  final sequences = 1;

  List<Widget> content(BuildContext context) {
    return [
      Text("GAIT INTRO"),
      Text("Active"),
      Text("GAIT INTRO 2"),
      Text("Active2")
      // TODO: implement content
    ];
  }

  Widget IntroSeq1(BuildContext context) => Text("TODO");

  Widget CaptureSeq1(BuildContext context) => Text("TODO");
}

class GaitNorms {
  GaitNorms._();
  //Numbers are in m/s and start in the 6-12, then 13-19, then 20-29, 30-39... to 80+
  static const maleNorm = [1.19, 1.2, 1.4, 1.48, 1.48, 1.4, 1.39, 1.34, 1.1];
  static const femaleNorm = [1.14, 1.2, 1.4, 1.4, 1.4, 1.39, 1.22, 1.19, 1.0];

  static double getVelocityFromAge(Gender gender, TemporalDate dob) {
    int age = getAge(dob);
    final int index = (age / 10).round().clamp(0, 8);
    return gender == Gender.MALE ? maleNorm[index] : femaleNorm[index];
  }

  static double getPercentDifferenceFromNorm(
      double patientVelocity, Gender gender, TemporalDate dob) {
    final double normVelocity = getVelocityFromAge(gender, dob);
    return (((patientVelocity - normVelocity) /
                ((patientVelocity + normVelocity) / 2)) *
            100)
        .roundToDouble();
  }
}

int getAge(TemporalDate dob) {
  return 10; //TODO implement
}

//TOOD PHASE OUT ASAP
class GaitPatientData {
  late String managingtherapistEmail = 'sample@example.com';
  late String firstname = 'sample';
  late String lastname = 'patient';
  late String bday = '01/01/1901';
  late bool isMale = true;
  late String age = '0';
  late String date = '01/01/1901';
  late String time = '00:00';
  late String velocity = "1.0";
  late double measurementDuration = 0.0;
  late bool isVideo = true;
  late String rawReportData = 'sample';
}

GaitPatientData gaitData = GaitPatientData();
