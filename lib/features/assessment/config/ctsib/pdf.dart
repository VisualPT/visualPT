import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:visualpt/core/utils/amplify_utils.dart';
import 'package:visualpt/core/utils/math_utils.dart';
import 'package:visualpt/features/assessment/service/assessment_utils.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/assessment/config/_pdf.dart';
import 'package:visualpt/features/assessment/config/ctsib/ctsib.dart';

class CtsibPDF extends PDF {
  final ctsib = CTSIB();
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
            Spacer(),
            assessmentData(subject, assessment),
            Spacer(),
            conditionRatioTable(assessment),
            Spacer(),
            normativeData(subject, assessment),
            Spacer(),
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

  Widget headerData() {
    return Header(
      child: Column(
        children: [
          RichTextLogo,
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(text: "${ctsib.name} Report", style: header),
              overflow: TextOverflow.span),
        ],
      ),
    );
  }

  Widget subjectData(Subject subject, Assessment assessment) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
          textAlign: TextAlign.left,
          text: TextSpan(text: "Patient Information", style: subHeader)),
      Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Name: ", style: detail),
              TextSpan(
                  text: "${subject.first_name} ${subject.last_name}",
                  style: detailBold),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "DOB: ", style: detail),
              TextSpan(
                  text: formatDate(subject.dob.getDateTime()),
                  style: detailBold),
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
                text:
                    formatDate(DateTime.parse(assessment.datetime.toString())),
                style: detailBold),
          ])),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Time: ", style: detail),
              TextSpan(
                  text: formatTime(
                      DateTime.parse(assessment.datetime.toString()).toLocal()),
                  style: detailBold),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Total Duration: ", style: detail),
              TextSpan(
                  text: formatDuration(assessment.duration), style: detailBold),
            ]),
          ),
        ]),
      ]),
    ]);
  }

  Widget assessmentData(Subject subject, Assessment assessment) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
          textAlign: TextAlign.left,
          text: TextSpan(text: "Assessment Information", style: subHeader)),
      Table(
        border: TableBorder.all(color: black),
        columnWidths: {
          for (var item in List.generate(8, (index) => index))
            item: const IntrinsicColumnWidth()
        },
        children: [
          // Create table header
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('#',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('Surface',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('Vision',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('Trials',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text('Avg Lat Sway (Max)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text('Avg Lon Sway (Max)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text('Leading Pose',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text('Equilibrium Score',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('Result',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
          for (int i = 0; i < (assessment.Conditions?.length ?? 1); i++)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text((i + 1).toString(),
                      style: detail, textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(ctsib.surface[i],
                      style: detail, textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(ctsib.vision[i],
                      style: detail, textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                      assessment.Conditions?[i].trials?.length.toString() ??
                          "0",
                      style: detail,
                      textAlign: TextAlign.center),
                ),
                Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                        "${CTSIB.averageSwayPerCondition(assessment)[i].$1.toStringAsFixed(2)} (${CTSIB.maxSwayPerCondition(assessment)[i].$1.toStringAsFixed(2)})°",
                        style: detail,
                        textAlign: TextAlign.center)),
                Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                        "${CTSIB.averageSwayPerCondition(assessment)[i].$2.toStringAsFixed(2)} (${CTSIB.maxSwayPerCondition(assessment)[i].$2.toStringAsFixed(2)})°",
                        style: detail,
                        textAlign: TextAlign.center)),
                Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                        CTSIB.getMostFrequentClassification(assessment, i),
                        style: detail,
                        textAlign: TextAlign.center)),
                Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                        CTSIB
                            .getEquilibriumScores(assessment)[i]
                            .toStringAsFixed(2),
                        style: detail,
                        textAlign: TextAlign.center)),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                      "${AssessmentUtils.getAvgDuration(assessment.Conditions?[i].trials).toStringAsFixed(1)} / 30",
                      style: detail,
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          // Create a table row for the total duration score
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('', textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('', textAlign: TextAlign.center),
              ),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                      assessment.Conditions?.fold(0,
                                  (curr, c) => curr + (c.trials?.length ?? 0))
                              .toString() ??
                          '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                      "${(CTSIB.averageSwayPerCondition(assessment).fold<(
                                double,
                                double
                              )>((
                                0.0,
                                0.0
                              ), (avg, sway) => (
                                avg.$1 + sway.$1,
                                avg.$2 + sway.$2
                              )).$1 / ctsib.conditions).toStringAsFixed(2)}°",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                      "${(CTSIB.averageSwayPerCondition(assessment).fold<(
                                double,
                                double
                              )>((
                                0.0,
                                0.0
                              ), (avg, sway) => (
                                avg.$1 + sway.$1,
                                avg.$2 + sway.$2
                              )).$2 / ctsib.conditions).toStringAsFixed(2)}°",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                      CTSIB.getMostFrequentIndexAcrossAllEntries(
                          CTSIB.getPredictionTotals(assessment)),
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                      CTSIB
                          .getEquilibriumScores(assessment)
                          .fold<double>(
                              0.0, (prevScore, score) => prevScore + score)
                          .toStringAsFixed(1),
                      style: detail,
                      textAlign: TextAlign.center)),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                    "${AssessmentUtils.getTotalAverageDuration(assessment).toStringAsFixed(1)} / ${30 * ctsib.conditions} seconds",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        ],
      ),
    ]);
  }

  Widget conditionRatioTable(Assessment assessment) {
    final c1 = AssessmentUtils.getAvgDuration(assessment.Conditions?[0].trials);
    final c2 = AssessmentUtils.getAvgDuration(assessment.Conditions?[1].trials);
    final c3 = AssessmentUtils.getAvgDuration(assessment.Conditions?[2].trials);
    final c4 = AssessmentUtils.getAvgDuration(assessment.Conditions?[3].trials);
    final c5 = AssessmentUtils.getAvgDuration(assessment.Conditions?[4].trials);
    final c6 = AssessmentUtils.getAvgDuration(assessment.Conditions?[5].trials);

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
              padding: const EdgeInsets.all(2.0),
              child:
                  Text('Test', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text('Ratio',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text('Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
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
    final totalDuration = assessment.Conditions?.map((s) => s.trials?.fold(0.0,
                (previousValue, element) => previousValue + element.duration))
            .reduce((a, b) => (a ?? 0.0) + (b ?? 0.0)) ??
        0.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
          textAlign: TextAlign.left,
          text: TextSpan(text: "Normative Comparison", style: subHeader)),
      RichText(
          text: TextSpan(
              text: getNormativeMessage(totalDuration, subject.dob),
              style: detail)),
    ]);
  }

  Widget interpretationData(Assessment assessment) {
    final is9xFallRisk = checkFallRisk(assessment);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
          textAlign: TextAlign.left,
          text: TextSpan(text: "Interpretation", style: subHeader)),
      if (is9xFallRisk)
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
              text:
                  "Patient displays deficits on Condition 5 and Condition 6 of the CTSIB which puts them at high risk (9x more likely) for a fall over the next 30 days.",
              style: detail),
        ),
      RichText(
          text: TextSpan(
              text: generateConditionRatioText(assessment), style: detail)),
      //             "1)	Vision Dependence: Patients become unstable in conditions 2, 3, 5 & 6 with eyes closed.",
      //             "2) Surface/somatosensory dependence: Patient becomes unstable in conditions 4, 5 & 6 because they stand on a soft surface (foam).",
      //             "3)	Vestibular loss: Patient becomes unstable in conditions 5 & 6 because they can't rely on vision or surface / somatosensory function.",
      //             "4)	Patients with sensory selection problems become unstable in conditions 3-6.",
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

  TableRow _createConditionRow(String testName, double ratio, String status) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(testName, style: detail),
      ),
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text("${ratio.toStringAsFixed(2)}%",
            style: detail, textAlign: TextAlign.center),
      ),
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(status, style: detail, textAlign: TextAlign.center),
      ),
    ]);
  }
}

String getNormativeMessage(double totalDuration, TemporalDate dob) {
  int age = getAge(dob);
  double norm = CTSIB.getAgeNorm(age);
  int percent =
      (((totalDuration - norm) / ((totalDuration + norm) / 2)) * 100).round();

  if (percent.abs() > 10) {
    return "Patients total time is ${totalDuration.toStringAsFixed(2)} / 180 seconds, which is ${percent.abs()}% of age norms, with a mean of $norm seconds";
  } else {
    return "Patient is within 10% of normative data, which has a mean of $norm seconds";
  }
}

String determineStatus(double ratio) {
  if (ratio == 0.0) {
    return "Inconclusive"; // Ratio is 0.0, indicating an invalid or uncalculable result
  } else if (ratio < 99) {
    return "Dysfunctional"; // System is dysfunctional if the ratio is less than 1
  } else {
    return "Functional"; // System is considered functional otherwise
  }
}

bool checkFallRisk(Assessment assessment) {
  // Calculate the total duration of the assessment (only for conditions 5 and 6)
  bool is9xFallRisk(int i) {
    final total =
        AssessmentUtils.getAvgDuration(assessment.Conditions?[i].trials) > 30.0;
    return total;
  }

  // Determine if the patient is at risk of falling based on the total duration
  return is9xFallRisk(4) || is9xFallRisk(5);
}

String generateConditionRatioText(Assessment assessment) {
  final c1 = AssessmentUtils.getAvgDuration(assessment.Conditions?[0].trials);
  final c2 = AssessmentUtils.getAvgDuration(assessment.Conditions?[1].trials);
  final c4 = AssessmentUtils.getAvgDuration(assessment.Conditions?[3].trials);
  final c5 = AssessmentUtils.getAvgDuration(assessment.Conditions?[4].trials);

  // Calculating ratios safely
  final somRatio = safeDivision(c2, c1);
  final visRatio = safeDivision(c4, c1);
  final vestRatio = safeDivision(c5, c1);

  final ratios = [
    (
      vestRatio,
      "Patient demonstrates a ${vestRatio.toStringAsFixed(2)}% ratio on the vestibular function test which puts them in the dysfunctional category."
    ),
    (
      visRatio,
      "Patient demonstrates a ${visRatio.toStringAsFixed(2)}% ratio on the visual dependence test which puts them in the dysfunctional category."
    ),
    (
      somRatio,
      "Patient demonstrates a ${somRatio.toStringAsFixed(2)}% ratio on the somatic sensory function test which puts them in the dysfunctional category."
    ),
  ];

  // Determine the worst ratio among the three
  final lowest = ratios.reduce((a, b) => a.$1 < b.$1 ? a : b);

  if (lowest.$1 > 99) {
    return "No significant findings were observed.";
  }

  return lowest.$2;
}
