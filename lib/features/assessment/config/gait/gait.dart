import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt_collector/core/utils/amplify_utils.dart';
import 'package:visualpt_collector/models/ModelProvider.dart';

class Gait {
  final sequences = 1;

  List<Widget> content(BuildContext context) {
    return [
      const Text("GAIT INTRO"),
      const Text("Active"),
      const Text("GAIT INTRO 2"),
      const Text("Active2")
      // TODO: implement content
    ];
  }

  Widget IntroSeq1(BuildContext context) => const Text("TODO");

  Widget CaptureSeq1(BuildContext context) => const Text("TODO");
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

// class GaitPatientData {
//   late String managingtherapistEmail = 'sample@example.com';
//   late String firstname = 'sample';
//   late String lastname = 'patient';
//   late String bday = '01/01/1901';
//   late bool isMale = true;
//   late String age = '0';
//   late String date = '01/01/1901';
//   late String time = '00:00';
//   late String velocity = "1.0";
//   late double measurementDuration = 0.0;
//   late bool isVideo = true;
//   late String rawReportData = 'sample';
// }

class GAITData {
  final num imageHeight;
  final num imageWidth;
  final num ratio;
  //final int classIndex;
  //final int conditionNumber;
  final int trialNumber;
  //final Patient patient; TODO: #140 Implement Patient Row in the Metadata @DrBubbles42 this should probably become a third row
  //final GaitDetectionOutput output;
  const GAITData(
    this.imageHeight,
    this.imageWidth,
    this.ratio,
    //this.classIndex,
    //this.conditionNumber,
    this.trialNumber,
    //this.output,
  );
  toCSV() {
    //final lines = output.output.map((line) => line.join(",")).join("\n");
    final metadata = [
      imageHeight,
      imageWidth,
      ratio,
      //classIndex,
      //conditionNumber,
      trialNumber
    ].join(",");
    return metadata;
  }
}
