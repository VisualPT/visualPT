import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/_views.dart';

class Ctsib {
  static const sequences = 4;
  Map<int, double> norms = {
    for (int i = 20; i <= 49; i++) i: 179.7,
    for (int i = 50; i <= 59; i++) i: 180.0,
    for (int i = 60; i <= 69; i++) i: 179.9,
    for (int i = 70; i <= 79; i++) i: 177.7,
  };

//TODO REMOVE NAME FROM BEING PASSED ALL AROUND THE PLACE
  List<Widget Function(BuildContext) Function(String)> introContent() {
    return [
      (name) => introView(name, "Eyes Open\nFirm Surface", 1),
      (name) => introView(name, "Eyes Closed\nFirm Surface", 2),
      (name) => introView(name, "Eyes Open\nFoam Surface", 3),
      (name) => introView(name, "Eyes Closed\nFoam Surface", 4),
    ];
  }

  List<Widget Function(BuildContext) Function(String)> captureContent() {
    return [
      (name) => captureView(name, "Eyes Open\nFirm Surface", 1),
      (name) => captureView(name, "Eyes Closed\nFirm Surface", 2),
      (name) => captureView(name, "Eyes Open\nFoam Surface", 3),
      (name) => captureView(name, "Eyes Closed\nFoam Surface", 4),
    ];
  }
}

Widget Function(BuildContext) introView(
  String assessmentName,
  String title,
  int index,
) =>
    (context) => BaseView(
          pageTitle: assessmentName,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Styles.title,
                textAlign: TextAlign.center,
              ),
              Text(
                  "Criteria ${index.toString()} of ${Ctsib.sequences.toString()}",
                  style: Styles.subactionText),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Ensure device is kept still"),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "Record all tests from same relative posiotion to patient",
                    textAlign: TextAlign.center),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.width / 2,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Styles.actionPrimary),
                      child: const Text("Begin", style: Styles.actionText),
                    ),
                    onTap: () => BlocProvider.of<AssessmentBloc>(context)
                        .add(AssessmentBegin(context: context))),
              ),
              const Spacer()
            ],
          ),
        );

Widget Function(BuildContext) captureView(
        String assessmentName, String title, int index) =>
    (context) => Builder(
          builder: (context) => Stack(
            children: [
              VideoView(
                sequence: index,
                onComplete: (segment) =>
                    BlocProvider.of<AssessmentBloc>(context).add(
                        AssessmentIncrement(
                            patient: BlocProvider.of<PatientBloc>(context)
                                .currentPatient,
                            segment: segment,
                            context: context)),
              ),
              Positioned(
                top: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: Styles.backgroundAccent),
                    child: SafeArea(
                      child: Text(title.replaceAll("\n", " "),
                          style: Styles.subtitle, textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

class CtsibNorms {
  CtsibNorms._();
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
