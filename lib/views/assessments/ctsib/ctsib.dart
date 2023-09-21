import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/_views.dart';

class Ctsib {
  static const sequences = 6;
  static const List<String> sequenceNames = [
    "Eyes Open Firm Surface",
    "Eyes Closed Firm Surface",
    "Visual Conflict Dome Firm Surface",
    "Eyes Open Foam Surface",
    "Eyes Closed Foam Surface",
    "Visual Conflict Dome Foam Surface",
  ];

//TODO REMOVE NAME FROM BEING PASSED ALL AROUND THE PLACE
  List<Widget Function(BuildContext) Function()> introContent() {
    return [
      () => introView("Eyes Open\nFirm Surface", 1),
      () => introView("Eyes Closed\nFirm Surface", 2),
      () => introView("Visual Conflict Dome\nFirm Surface", 3),
      () => introView("Eyes Open\nFoam Surface", 4),
      () => introView("Eyes Closed\nFoam Surface", 5),
      () => introView("Visual Conflict Dome\nFoam Surface", 6)
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

Widget Function(BuildContext) introView(
  String title,
  int index,
) =>
    (context) => BaseView(
          pageTitle: "CTSIB",
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Text(
                  "Criteria ${index.toString()} of ${Ctsib.sequences.toString()}",
                  style: Styles.subactionText),
              const Spacer(),
              Container(
                height: 2,
                width: MediaQuery.of(context).size.width * 0.8,
                color: Styles.black,
              ),
              Text(
                title,
                style: Styles.title,
                textAlign: TextAlign.center,
              ),
              Container(
                height: 2,
                width: MediaQuery.of(context).size.width * 0.8,
                color: Styles.black,
              ),
              const Spacer(),
              const Text("Before getting started: ",
                  style: Styles.heading3, textAlign: TextAlign.center),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Ensure device is kept still"),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "Record all tests from same relative position to patient",
                    textAlign: TextAlign.center),
              ),
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CupertinoButton(
                      color: Styles.actionPrimary,
                      onPressed: () => BlocProvider.of<AssessmentBloc>(context)
                          .add(AssessmentBegin(context: context, index: index)),
                      child: const Text("Begin", style: Styles.actionText))),
              const Spacer()
            ],
          ),
        );

Widget Function(BuildContext) captureView(
        Patient patient, String title, int index) =>
    (context) => BaseView(
        pageTitle: title,
        child: VideoView(
          (BlocProvider.of<AuthBloc>(context).state as AuthSuccess)
                  .user
                  .email !=
              'gaitertech@gmail.com', //TODO; This needs to be improved, THE WHOLE FILE
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
