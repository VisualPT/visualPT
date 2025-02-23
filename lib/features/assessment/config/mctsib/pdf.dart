import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/models/ModelProvider.dart';

class MctsibPDF extends BasePDF {
  final mctsib = MCTSIB();
  @override
  Future<Uint8List> generatePdf(Profile profile, Assessment assessment) async {
    await configPdfStyles();

    final norms = await mctsib.getNorms(profile.dob, profile.gender);

    final pdf = Document(
        title: profile.lastName + profile.firstName + profile.dob.toString(),
        creator: "VisualPT Systems");

    pdf.addPage(
      Page(
        pageTheme: const PageTheme(
          pageFormat: PdfPageFormat.letter,
          margin: EdgeInsets.all(halfinch),
        ),
        build: (Context context) => SizedBox(
          height: 11 * inch,
          width: 8.5 * inch,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            headerData(),
            subjectData(profile, assessment),
            Spacer(),
            assessmentData(profile, assessment),
            Spacer(),
            conditionRatioTable(assessment),
            Spacer(),
            normativeData(assessment, norms),
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
              text: TextSpan(text: "${mctsib.name} Report", style: header),
              overflow: TextOverflow.span),
        ],
      ),
    );
  }

  Widget subjectData(Profile profile, Assessment assessment) {
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
                  text: "${profile.firstName} ${profile.lastName}",
                  style: detailBold),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "DOB: ", style: detail),
              TextSpan(
                  text: FormatUtil.date(profile.dob.getDateTime()),
                  style: detailBold),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Age: ", style: detail),
              TextSpan(
                  text: (DateTime.now()
                              .difference(profile.dob.getDateTime())
                              .inDays ~/
                          365)
                      .toString(),
                  style: detailBold), //TODO DOB to age
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Gender: ", style: detail),
              TextSpan(text: profile.gender.name, style: detailBold),
            ]),
          ),
        ]),
        Spacer(),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(text: "Date: ", style: detail),
            TextSpan(
                text: FormatUtil.date(
                    assessment.createdAt.getDateTimeInUtc().toLocal()),
                style: detailBold),
          ])),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Time: ", style: detail),
              TextSpan(
                  text: FormatUtil.time(
                      assessment.createdAt.getDateTimeInUtc().toLocal()),
                  style: detailBold),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Total Duration: ", style: detail),
              TextSpan(
                  text: FormatUtil.duration(assessment.duration),
                  style: detailBold),
            ]),
          ),
        ]),
      ]),
    ]);
  }

  Widget assessmentData(Profile profile, Assessment assessment) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
          textAlign: TextAlign.left,
          text: TextSpan(text: "Assessment Information", style: subHeader)),
      Table(
        border: TableBorder.all(color: black),
        columnWidths: {
          0: const IntrinsicColumnWidth(),
          1: const IntrinsicColumnWidth(),
          2: const IntrinsicColumnWidth(),
        },
        children: [
          // Create table header
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text('#',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text('Surface',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text('Vision',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text('Trials',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text('Avg Lat Sway (Max)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text('Avg Lng Sway (Max)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text('Equilibrium Score',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text('Result',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
          for (int i = 0; i < (assessment.stages?.length ?? 1); i++)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text((i + 1).toString(),
                      style: detail, textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(mctsib.surface[i],
                      style: detail, textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(mctsib.vision[i],
                      style: detail, textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                      assessment.stages?[i].trials?.length.toString() ?? "0",
                      style: detail,
                      textAlign: TextAlign.center),
                ),
                Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                        "${CTSIB.averageSwayPerCondition(assessment)[i].$1.toStringAsFixed(2)} (${CTSIB.maxSwayPerCondition(assessment)[i].$1.toStringAsFixed(2)})°",
                        style: detail,
                        textAlign: TextAlign.center)),
                Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                        "${CTSIB.averageSwayPerCondition(assessment)[i].$2.toStringAsFixed(2)} (${CTSIB.maxSwayPerCondition(assessment)[i].$2.toStringAsFixed(2)})°",
                        style: detail,
                        textAlign: TextAlign.center)),
                Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                        mctsib
                            .calculateScores(assessment)[i]
                            .toStringAsFixed(2),
                        style: detail,
                        textAlign: TextAlign.center)),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                      "${AssessmentUtils.getAvgDuration(assessment.stages?[i].trials).toStringAsFixed(1)} / 30",
                      style: detail,
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          // Create a table row for the total duration score
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text('Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text('', textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text('', textAlign: TextAlign.center),
              ),
              Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                      assessment.stages
                              ?.fold(0,
                                  (curr, c) => curr + (c.trials?.length ?? 0))
                              .toString() ??
                          '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              Padding(
                  padding: const EdgeInsets.all(3.0),
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
                              )).$1 / mctsib.stages).toStringAsFixed(2)}°",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              Padding(
                  padding: const EdgeInsets.all(3.0),
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
                              )).$2 / mctsib.stages).toStringAsFixed(2)}°",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                      mctsib
                          .calculateScores(assessment)
                          .fold<double>(
                              0.0, (prevScore, score) => prevScore + score)
                          .toStringAsFixed(1),
                      style: detail,
                      textAlign: TextAlign.center)),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                    "${AssessmentUtils.getTotalAverageDuration(assessment).toStringAsFixed(1)} / ${30 * mctsib.stages} seconds",
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
    // Calculating ratios safely
    const somRatio = 0.0; //FIXME:
    const visRatio = 0.0; //FIXME:

// Now you can directly pass the string representations of ratios to determineStatus
    final somStatus = determineStatus(somRatio);
    final visStatus = determineStatus(visRatio);

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
              child: Text('Ratio',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text('Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
          ]),
          _createConditionRow("Somatosensory (SOM) Test", somRatio, somStatus),
          _createConditionRow(
              "Visual Dependence (VIS) Test", visRatio, visStatus),
        ],
      )
    ]);
  }

  Widget normativeData(Assessment assessment, List<Norm>? norms) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
          textAlign: TextAlign.left,
          text: TextSpan(text: "Normative Comparison", style: subHeader)),
      RichText(
          text: TextSpan(
              text: mctsib.getNormativeMessage(assessment, norms),
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
              text: generateConditionRatioText(assessment), style: detail)),
    ]);
  }

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
        padding: const EdgeInsets.all(3.0),
        child: Text(testName, style: detail),
      ),
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text("${ratio.toStringAsFixed(2)}%",
            style: detail, textAlign: TextAlign.center),
      ),
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(status, style: detail, textAlign: TextAlign.center),
      ),
    ]);
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

String generateConditionRatioText(Assessment assessment) {
  // Calculating ratios safely
  const somRatio = 0.0; //FIXME
  const visRatio = 0.0; //FIXME;

  final ratios = [
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
