import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/assessments/_pdf.dart';
import 'package:visualpt/views/assessments/ctsib/ctsib.dart';

class CtsibPDF extends PDF {
  @override
  Future<Uint8List> generatePdf(Patient patient, Assessment assessment) async {
    await configPdfStyles();

    final pdf = Document(
        title: patient.last_name + patient.first_name + patient.dob.toString(),
        creator: "VisualPT Systems");

    pdf.addPage(
      Page(
        pageTheme: PageTheme(
          pageFormat: PdfPageFormat.letter,
          margin: EdgeInsets.all(halfinch),
        ),
        build: (Context context) => SizedBox(
          height: 11 * inch,
          width: 9.5 * inch,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            headerData(),
            patientData(patient, assessment),
            assessmentData(patient, assessment),
            normativeData(patient),
            Spacer(),
            diagnosisData(),
            Spacer(flex: 2),
            footerData(),
          ]),
        ),
      ),
    );
    return pdf.save();
  }

  List<Widget> axisLabel() {
    final values = List<double>.generate(9, (i) => i * 0.2)
        .map<Text>((value) => value >= 1.0
            ? Text(value.toStringAsPrecision(2))
            : Text(value.toStringAsPrecision(1)))
        .toList();
    return List<Widget>.generate(
        17, (i) => i % 2 == 0 ? values[i ~/ 2] : Spacer());
  }

  double positioner(String velocity) =>
      (2.95 * inch * double.parse(velocity)).clamp(0 * inch, 4.75 * inch);

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
        ],
      ),
    );
  }

  Widget patientData(Patient patient, Assessment assessment) {
    return SizedBox(
      height: 3 * inch,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: disclaimer,
                text:
                    "VisualPT computer vision system with machine learning to detect sensory and balance impairments")),
        Spacer(),
        RichText(text: TextSpan(text: "Patient Information", style: subHeader)),
        SizedBox(
            height: 2.0 * inch,
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(text: "Name: ", style: detail),
                    TextSpan(
                        text: "${patient.first_name} ${patient.last_name}",
                        style: detailBold),
                  ]),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(text: "DOB: ", style: detail),
                    TextSpan(text: patient.dob.toString(), style: detailBold),
                  ]),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(text: "Age: ", style: detail),
                    TextSpan(
                        text: (DateTime.now()
                                    .difference(patient.dob.getDateTime())
                                    .inDays ~/
                                365)
                            .toString(),
                        style: detailBold), //TODO DOB to age
                  ]),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(text: "Gender: ", style: detail),
                    TextSpan(text: patient.gender.name, style: detailBold),
                  ]),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(text: "Duration: ", style: detail),
                    TextSpan(
                        text: assessment.duration.toString(),
                        style: detailBold),
                    TextSpan(text: " seconds", style: detail),
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
                ])),
                Spacer(),
              ]),
            ])),
      ]),
    );
  }

  Widget assessmentData(Patient patient, Assessment assessment) {
    int index = 0;
    return SizedBox(
        height: 3.5 * inch,
        child: Column(children: [
          RichText(
              textAlign: TextAlign.left,
              text: TextSpan(text: "Assessment Information", style: subHeader)),
          Table(
            border: TableBorder.all(color: black),
            columnWidths: {
              0: const FlexColumnWidth(3),
              1: const FlexColumnWidth(6),
              2: const FlexColumnWidth(4),
            },
            children: [
              // Create table header
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(''),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Condition',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Result',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              // Create a table row for each segment
              for (Segment segment in assessment.segments!)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text((index + 1).toString()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(Ctsib.sequenceNames[index++]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "${segment.duration_seconds.toString()} / 30 seconds"),
                    ),
                  ],
                ),
              // Create a table row for the total duration score
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Total Score',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${assessment.segments!.map((s) => s.duration_seconds).reduce((a, b) => a + b).toString()} / ${30 * Ctsib.sequences} seconds",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]));
  }

  Widget interpretationData(Assessment assessment) {
    return Column(children: [
      RichText(text: TextSpan(text: "Interpretation", style: subHeader)),
      ListView(
        spacing: 2.0,
        children: [
          RichText(
              text: TextSpan(
                  text:
                      "1)	Vision Dependence: Patients become unstable in conditions 2, 3, 5 & 6 with eyes closed.",
                  style: detailBold)),
          RichText(
              text: TextSpan(
                  text:
                      "2) Surface/somatosensory dependence: Patient becomes unstable in conditions 4, 5 & 6 because they stand on a soft surface (foam).",
                  style: detailBold)),
          RichText(
              text: TextSpan(
                  text:
                      "3)	Vestibular loss: Patient becomes unstable in conditions 5 & 6 because they can't rely on vision or surface / somatosensory function.",
                  style: detailBold)),
          RichText(
              text: TextSpan(
                  text:
                      "4)	Patients with sensory selection problems become unstable in conditions 3-6.",
                  style: detailBold)),
        ],
      )
    ]);
  }

//TODO: Add normative data, and potientally another data field for collecting the patients fall history
  Widget normativeData(Patient patient) {
    return Column(children: [
      RichText(text: TextSpan(text: "Normative Comparison", style: subHeader)),
      RichText(text: TextSpan(text: "Coming Soon", style: detailBold)),
    ]);
  }

  Widget diagnosisData() {
    return Column(children: [
      RichText(
          text: TextSpan(text: "Diagnostic Information", style: subHeader)),
      RichText(text: TextSpan(text: "THIS IS A DEMO", style: detailBold)),
    ]);
  }

  Widget footerData() {
    return Footer(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      leading: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(text: TextSpan(text: " ", style: invisible)),
            RichText(
                text: TextSpan(
                    style: disclaimer,
                    text: "© 2022 VisualPT, Inc. All Rights Reserved")),
            RichText(
                text: TextSpan(
                    style: disclaimer,
                    text: "No Distribution without Permission")),
          ]),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // RichText(
          //     text: TextSpan(
          //         style: disclaimer,
          //         text: "Minimal Detectable Change: 0.1m/sec")),
          // RichText(
          //     text: TextSpan(
          //         style: disclaimer,
          //         text: "Minimum Clinically Important Difference: 0.1m/sec")),
          // RichText(
          //     text: TextSpan(
          //         style: disclaimer,
          //         text: "Test/Re-test Reliability: ICC > 0.7"))
        ],
      ),
    );
  }
}

// String getComparisonMessage(double velocity, Gender gender, TemporalDate dob) {
//   double percent =
//       CtsibNorms.getPercentDifferenceFromNorm(velocity, gender, dob);
//   int age = getAge(dob);
//   int index = (age / 10).round();
//   String speedComparison = percent > 0 ? "faster" : "slower";
//   String ageRange = index > 8 ? "80+" : "${index}0 - ${index}9";
//   return percent.abs() > 5.0
//       ? "Among $ageRange year olds, you are ${percent.abs()}% $speedComparison than average."
//       : "Your gait velocity matches your peer group aged $ageRange.";
// }
