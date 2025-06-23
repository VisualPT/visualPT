import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/models/ModelProvider.dart';

class MctsibPDF extends BasePDF {
  final mctsib = MCTSIB();
  @override
  Future<Uint8List> generatePdf(Profile profile, Assessment assessment,
      Map<String, dynamic> params) async {
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
            assessmentData(profile, assessment, norms),
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

  Widget assessmentData(
      Profile profile, Assessment assessment, List<Norm>? norms) {
    final scores = mctsib.calculateScores(assessment);

    final trialCount = int.parse(jsonDecode(assessment.extra)['trial count']);
    final margins = trialCount == 1
        ? [30.0, 30.0]
        : trialCount == 2
            ? [26.0, 34.0]
            : [23.0, 38.0];

    final compositeColor = scores
                    .expand((stage) => stage)
                    .reduce((a, b) => a + b) /
                (scores.expand((stage) => stage).length) >
            (norms?.map((norm) => norm.scoreSum).reduce((a, b) => a + b) ?? 0) /
                (norms?.map((norm) => norm.trialSum).reduce((a, b) => a + b) ??
                    1)
        ? PdfColors.green
        : PdfColors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            textAlign: TextAlign.left,
            text: TextSpan(text: "Assessment Score", style: subHeader)),
        Container(
          padding: const EdgeInsets.only(top: 10),
          height: 220, // Increase height for better visibility
          child: Stack(
            children: [
              // Background chart for norm scores (gray background)
              Chart(
                grid: CartesianGrid(
                  xAxis: FixedAxis.fromStrings(
                    List.generate(
                      (assessment.stages?.length ?? 0) + 1,
                      (i) => i < mctsib.stages
                          ? '${mctsib.vision[i]} \n ${mctsib.surface[i]}'
                          : 'Composite',
                    ),
                    textStyle: TextStyle(fontSize: 10, font: baseFont),
                    marginStart: 30,
                    marginEnd: 30,
                  ),
                  yAxis: FixedAxis(
                    [0, 25, 50, 75, 100],
                    format: (v) => '$v',
                    marginStart: 1,
                  ),
                ),
                datasets:
                    List.generate(((assessment.stages?.length ?? 0) + 1), (i) {
                  return BarDataSet(
                    legend: '',
                    color: PdfColors.grey, // Normative background
                    data: [
                      PointChartValue(
                          (i).toDouble(),
                          (norms?[i].scoreSum ?? 0) /
                              ((norms?[i].trialSum ?? 1)))
                    ],
                    valuePosition: ValuePosition.auto,
                    width: 30,
                  );
                }),
              ),
              // Foreground chart for patient scores
              ...List.generate(
                (assessment.stages?.length ?? 0),
                (i) {
                  return Chart(
                    grid: CartesianGrid(
                      xAxis: FixedAxis.fromStrings(
                        List.generate(
                          (assessment.stages?.length ?? 0) + 1,
                          (i) => '\n\n',
                        ),
                        textStyle: TextStyle(fontSize: 10, font: baseFont),
                        marginStart: margins[0],
                        marginEnd: margins[1],
                      ),
                      yAxis: FixedAxis(
                        [0, 25, 50, 75, 100],
                        format: (v) => '$v',
                        marginStart: 1,
                        divisions: true,
                        divisionsColor:
                            PdfColor.fromInt(Styles.activeOrange.toARGB32()),
                      ),
                    ),
                    datasets: scores[i].asMap().entries.map((entry) {
                      return BarDataSet(
                        legend: '',
                        width: scores[i].length == 1 ? 20 : 5,
                        color: entry.value >
                                (norms?[i].scoreSum ?? 0) /
                                    ((norms?[i].trialSum ?? 1))
                            ? PdfColors.green
                            : PdfColors.red,
                        data: [
                          PointChartValue(
                            (i + entry.key * 0.1).toDouble(),
                            entry.value,
                          )
                        ],
                        buildValue: (context, point) => Text(
                            point.y == 0 ? "F" : point.y.toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: 10,
                              font: baseFont,
                            )),
                        valuePosition: ValuePosition.auto,
                      );
                    }).toList(),
                  );
                },
              ),
              // Composite chart
              Chart(
                grid: CartesianGrid(
                  xAxis: FixedAxis.fromStrings(
                    List.generate(
                      (assessment.stages?.length ?? 0) + 1,
                      (i) => i < mctsib.stages
                          ? '${mctsib.vision[i]} \n ${mctsib.surface[i]}'
                          : 'Composite',
                    ),
                    textStyle: TextStyle(fontSize: 10, font: baseFont),
                    marginStart: 30,
                    marginEnd: 30,
                  ),
                  yAxis: FixedAxis(
                    [0, 25, 50, 75, 100],
                    format: (v) => '$v',
                    marginStart: 1,
                  ),
                ),
                datasets: [
                  BarDataSet(
                    legend: '',
                    color: compositeColor,
                    data: [
                      PointChartValue(
                          (assessment.stages?.length ?? 0).toDouble(),
                          scores
                                  .expand((stage) => stage)
                                  .reduce((a, b) => a + b) /
                              (scores.expand((stage) => stage).length))
                    ],
                    buildValue: (context, point) =>
                        Text(point.y == 0 ? "F" : point.y.toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: 10,
                              font: baseFont,
                            )),
                    valuePosition: ValuePosition.auto,
                    width: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
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
