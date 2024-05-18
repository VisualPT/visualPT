import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:visualpt/core/utils/amplify_utils.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/assessment/config/_pdf.dart';
import 'package:visualpt/features/assessment/config/ctsib/ctsib.dart';

class CtsibPDF extends PDF {
  @override
  Future<Uint8List> generatePdf(Subject subject, Assessment assessment) async {
    await configPdfStyles();

    final pdf = Document(
        title: subject.last_name + subject.first_name + subject.dob.toString(),
        creator: "VisualPT Systems");

    pdf.addPage(
      Page(
        pageTheme: PageTheme(
          pageFormat: PdfPageFormat.letter,
          margin: EdgeInsets.all(halfinch),
        ),
        build: (Context context) => SizedBox(
          height: 11 * inch,
          width: 8.5 * inch,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            headerData(),
            subjectData(subject, assessment),
            assessmentData(subject, assessment),
            conditionRatioTable(assessment),
            normativeData(subject, assessment),
            interpretationData(assessment),
            //diagnosisData(),
            Spacer(),
            footerData(),
          ]),
        ),
      ),
    );
    return pdf.save();
  }

  // List<Widget> axisLabel() {
  //   final values = List<double>.generate(9, (i) => i * 0.2)
  //       .map<Text>((value) => value >= 1.0
  //           ? Text(value.toStringAsPrecision(2))
  //           : Text(value.toStringAsPrecision(1)))
  //       .toList();
  //   return List<Widget>.generate(
  //       17, (i) => i % 2 == 0 ? values[i ~/ 2] : Spacer());
  // }

  // double positioner(String velocity) =>
  //     (2.95 * inch * double.parse(velocity)).clamp(0 * inch, 4.75 * inch);

  Widget headerData() {
    return Header(
      child: Column(
        children: [
          RichTextLogo,
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "Clinical Test of Sensory Integration & Balance Report",
                  style: header),
              overflow: TextOverflow.span),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: disclaimer,
                  text:
                      "VisualPT computer vision system with machine learning to detect sensory and balance impairments")),
        ],
      ),
    );
  }

  Widget subjectData(Subject subject, Assessment assessment) {
    return SizedBox(
      height: 1.3 * inch,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        RichText(
            textAlign: TextAlign.left,
            text: TextSpan(text: "Patient Information", style: subHeader)),
        Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(text: "Name: ", style: detail),
                TextSpan(
                    text: "Anonymous Data Collection",
                    //TODO: text: "${subject.first_name} ${subject.last_name}",
                    style: detailBold),
              ]),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: "DOB: ", style: detail),
                TextSpan(text: subject.dob.toString(), style: detailBold),
              ]),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: "Age: ", style: detail),
                TextSpan(
                    text: (DateTime.now()
                                .difference(subject.dob.getDateTime())
                                .inDays ~/
                            365)
                        .toString(),
                    style: detailBold), //TODO DOB to age
              ]),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: "Gender: ", style: detail),
                TextSpan(text: subject.gender.name, style: detailBold),
              ]),
            ),
          ]),
          Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            //TODO internationalize this date format to local time
            RichText(
                text: TextSpan(children: [
              TextSpan(text: "Date: ", style: detail),
              TextSpan(
                  text: DateTime.parse(assessment.datetime.toString())
                      .toLocal()
                      .toIso8601String()
                      .substring(0, 10),
                  style: detailBold),
            ])),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: "Time: ", style: detail),
                TextSpan(
                    text: DateTime.parse(assessment.datetime.toString())
                        .toLocal()
                        .toIso8601String()
                        .substring(11)
                        .split('.')[0]
                        .substring(0, 5),
                    style: detailBold),
              ]),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: "Total Duration: ", style: detail),
                TextSpan(
                    text: assessment.duration.toString(), style: detailBold),
                TextSpan(text: " seconds", style: detail),
              ]),
            ),
          ]),
        ]),
      ]),
    );
  }

  Widget assessmentData(Subject subject, Assessment assessment) {
    final ctsib = CTSIB();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
          textAlign: TextAlign.left,
          text: TextSpan(text: "Assessment Information", style: subHeader)),
      Table(
        border: TableBorder.all(color: black),
        columnWidths: {
          0: const FlexColumnWidth(2),
          1: const FlexColumnWidth(6),
          2: const FlexColumnWidth(4),
        },
        children: [
          // Create table header
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(''),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text('Condition',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text('Result',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          // Create a table row for each segment
          for (int i = 0; i < assessment.Conditions!.length; i++)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text((i + 1).toString(), style: detail),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(ctsib.seqNames[i], style: detail),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                      "${assessment.Conditions![i].duration.toString()} / 30 seconds",
                      style: detail),
                ),
              ],
            ),
          // Create a table row for the total duration score
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text('Total Score',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(''),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "${assessment.Conditions!.map((s) => s.duration).reduce((a, b) => a + b).toString()} / ${30 * ctsib.sequences} seconds",
                ),
              ),
            ],
          ),
        ],
      ),
    ]);
  }

  Widget conditionRatioTable(Assessment assessment) {
    // Assuming assessment.conditions contains data for conditions in order: C1, C2, C3, C4, C5, C6
    final c1 = assessment.Conditions![0].duration;
    final c2 = assessment.Conditions![1].duration;
    final c3 = assessment.Conditions![2].duration;
    final c4 = assessment.Conditions![3].duration;
    final c5 = assessment.Conditions![4].duration;
    final c6 = assessment.Conditions![5].duration;

    // Calculating ratios safely
    final somRatio = safeDivision(c2, c1);
    final visRatio = safeDivision(c4, c1);
    final vestRatio = safeDivision(c5, c1);
    final prefRatio = safeDivision((c3 + c6), (c2 + c5));

// Now you can directly pass the string representations of ratios to determineStatus
    final somStatus = determineStatus(somRatio);
    final visStatus = determineStatus(visRatio);
    final vestStatus = determineStatus(vestRatio);
    final prefStatus = determineStatus(prefRatio);

    // Creating a table to display the results
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
          textAlign: TextAlign.left,
          text:
              TextSpan(text: "Condition Ratio Information", style: subHeader)),
      Table(
        border: TableBorder.all(color: black),
        children: [
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child:
                  Text('Test', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child:
                  Text('Ratio', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child:
                  Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ]),
          _createConditionRow("Somatosensory (SOM) Test", somRatio, somStatus),
          _createConditionRow(
              "Visual Dependence (VIS) Test", visRatio, visStatus),
          _createConditionRow(
              "Vestibular Function (VEST) Test", vestRatio, vestStatus),
          _createConditionRow(
              "Preferred Sensory System (PREF) Test", prefRatio, prefStatus),
        ],
      )
    ]);
  }

  //TODO: Add normative data, and potientally another data field for collecting the patients fall history
  Widget normativeData(Subject subject, Assessment assessment) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
          textAlign: TextAlign.left,
          text: TextSpan(text: "Normative Comparison", style: subHeader)),
      RichText(
          text: TextSpan(
              text: getNormativeMessage(
                  assessment.Conditions!
                      .map((s) => s.duration)
                      .reduce((a, b) => a + b),
                  subject.dob),
              style: detail)),
    ]);
  }

  Widget interpretationData(Assessment assessment) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
          textAlign: TextAlign.left,
          text: TextSpan(text: "Interpretation", style: subHeader)),
      RichText(
          text: TextSpan(
              text:
                  "1)	Vision Dependence: Patients become unstable in conditions 2, 3, 5 & 6 with eyes closed.",
              style: disclaimer)),
      RichText(
          text: TextSpan(
              text:
                  "2) Surface/somatosensory dependence: Patient becomes unstable in conditions 4, 5 & 6 because they stand on a soft surface (foam).",
              style: disclaimer)),
      RichText(
          text: TextSpan(
              text:
                  "3)	Vestibular loss: Patient becomes unstable in conditions 5 & 6 because they can't rely on vision or surface / somatosensory function.",
              style: disclaimer)),
      RichText(
          text: TextSpan(
              text:
                  "4)	Patients with sensory selection problems become unstable in conditions 3-6.",
              style: disclaimer)),
    ]);
  }

  // Widget diagnosisData() {
  //   return Column(children: [
  //     RichText(
  //         text: TextSpan(text: "Diagnostic Information", style: subHeader)),
  //     RichText(text: TextSpan(text: "Coming Soon", style: detailBold)),
  //   ]);
  // }

  Widget footerData() {
    return Footer(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      trailing: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RichText(text: TextSpan(text: " ", style: invisible)),
            RichText(
                text: TextSpan(
                    style: disclaimer,
                    text: "© 2024 VisualPT.AI, LLC. All Rights Reserved")),
            RichText(
                text: TextSpan(
                    style: disclaimer,
                    text: "No Distribution without Permission")),
          ]),
      // trailing: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   children: [
      //     // RichText(
      //     //     text: TextSpan(
      //     //         style: disclaimer,
      //     //         text: "Minimal Detectable Change: 0.1m/sec")),
      //     // RichText(
      //     //     text: TextSpan(
      //     //         style: disclaimer,
      //     //         text: "Minimum Clinically Important Difference: 0.1m/sec")),
      //     // RichText(
      //     //     text: TextSpan(
      //     //         style: disclaimer,
      //     //         text: "Test/Re-test Reliability: ICC > 0.7"))
      //   ],
      // ),
    );
  }

  TableRow _createConditionRow(String testName, String ratio, String status) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(testName),
      ),
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text("${ratio * 100}%"),
      ),
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(status),
      ),
    ]);
  }
}

String getNormativeMessage(double totalDuration, TemporalDate dob) {
  int age = getAge(dob);
  double norm = CTSIB.getAgeNorm(age);
  double percent =
      (((totalDuration - norm) / ((totalDuration + norm) / 2)) * 100)
          .roundToDouble();

  if (percent < -10) {
    return "Patient is ${percent.abs()}% better than normative data, which has a mean of $norm seconds";
  } else if (percent > 10) {
    return "Patient is ${percent.abs()}% worse than normative data, which has a mean of $norm seconds";
  } else {
    return "Patient is within 10% of normative data, which has a mean of $norm seconds";
  }
}

// Safe division function to handle NaN or Infinity
String safeDivision(double numerator, double denominator) {
  if (denominator == 0 || numerator.isNaN || denominator.isNaN) {
    return "Inconclusive";
  } else {
    final ratio = numerator / denominator;
    if (ratio.isNaN || ratio.isInfinite) {
      return "Inconclusive";
    } else {
      return ratio.toStringAsPrecision(2) * 100;
    }
  }
}

String determineStatus(String ratioStr) {
  // Attempt to parse the ratio string to double
  double ratio;
  try {
    ratio = double.parse(ratioStr);
  } catch (e) {
    // If parsing fails, consider the ratio as invalid
    return "Inconclusive";
  }

  // Determine the status based on the parsed ratio value
  if (ratio == 0.0) {
    return "Inconclusive"; // Ratio is 0.0, indicating an invalid or uncalculable result
  } else if (ratio < 1) {
    return "Dysfunctional"; // System is dysfunctional if the ratio is less than 1
  } else {
    return "Functional"; // System is considered functional otherwise
  }
}
