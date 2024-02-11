import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/assessment/bloc/assessment_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/core/views/_views.dart';
import 'package:visualpt/features/assessment/view/ctsib/instruction_view.dart';

class Berg {
  static const sequences = 6;
  static const List<String> sequenceNames = [
    "Standing Unsupported with Feet Together",
    "Standing on One Leg",
    "Pick Up Object from the Floor",
    "Turning to Look Over Left and Right Shoulders",
    "Turning 360 Degrees",
    "Sitting Down",
  ];

  List<Widget Function(BuildContext) Function()> introContent() {
    return [
      () => (context) => const InstructionView("Eyes Open\nFirm Surface", 1),
      () => (context) => const InstructionView("Eyes Closed\nFirm Surface", 2),
      () => (context) =>
          const InstructionView("Visual Conflict Dome\nFirm Surface", 3),
      () => (context) => const InstructionView("Eyes Open\nFoam Surface", 4),
      () => (context) => const InstructionView("Eyes Closed\nFoam Surface", 5),
      () => (context) =>
          const InstructionView("Visual Conflict Dome\nFoam Surface", 6)
    ];
  }

  List<Widget Function(BuildContext) Function(Patient)> captureContent() {
    return [
      (patient) => captureView(patient, "Eyes Open\nFirm Surface", 1),
      (patient) => captureView(patient, "Eyes Closed\nFirm Surface", 2),
      (patient) =>
          captureView(patient, "Visual Conflict Dome\nFirm Surface", 3),
      (patient) => captureView(patient, "Eyes Open\nFoam Surface", 4),
      (patient) => captureView(patient, "Eyes Closed\nFoam Surface", 5),
      (patient) =>
          captureView(patient, "Visual Conflict Dome\nFoam Surface", 6),
    ];
  }
}

Widget Function(BuildContext) captureView(
        Patient patient, String title, int index) =>
    (context) => BaseView(
        pageTitle: title,
        child: CaptureView(
          (segment) => BlocProvider.of<AssessmentBloc>(context).add(
              AssessmentIncrement(
                  patient: patient,
                  segment: segment,
                  index: index,
                  context: context)),
        ));

class CtsibNorms {
  CtsibNorms._();
  //Numbers are in m/s and start in the 6-12, then 13-19, then 20-29, 30-39... to 80+
  static const norms = [179.7, 180.0, 179.9, 177.7];
  static const ageGroups = [20, 49, 59, 69, 79];

  static double getAgeNorm(int age) {
    final int index = ageGroups.indexWhere((element) => element > age);
    return norms[index];
  }
}

int getAge(TemporalDate dob) {
  //Converts an Amplify TemporalDate to a difference in time by years and returns that as an int
  final now = TemporalDate.now();
  return now.getDateTime().year - dob.getDateTime().year;
}
