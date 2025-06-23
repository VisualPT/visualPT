import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/features/assessment/types.dart';
import 'package:visualpt/models/ModelProvider.dart';

class CtsibPDF extends BasePDF {
  final ctsib = CTSIB();
  @override
  Future<Uint8List> generatePdf(Profile profile, Assessment assessment,
      Map<String, dynamic> params) async {
    await configPdfStyles();

    final norms = await ctsib.getNorms(profile.dob, profile.gender);

    final pdf = Document(
        title: profile.lastName + profile.firstName + profile.dob.toString(),
        creator: "VisualPT Systems");

    final detectionParams = DetectionParams(
      sensitivity: params.putIfAbsent('sensitivity', () => (1.0, 1.0)),
      offset: params.putIfAbsent('offset', () => (0.0, 0.0)),
      deviceCorrection: params.putIfAbsent('deviceCorrection', () => true),
    );

    final scores = ctsib.calculateScores(assessment, params: detectionParams);

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
            subjectData(profile, assessment, detectionParams),
            Spacer(),
            assessmentData(scores, norms),
            Spacer(),
            sensoryMismatchData(scores, norms),
            Spacer(),
            // normativeData(assessment, norms, params: detectionParams),
            // Spacer(),
            // interpretationData(assessment),
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

  Widget subjectData(
      Profile profile, Assessment assessment, DetectionParams params) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
          textAlign: TextAlign.left,
          text: TextSpan(text: "Assessment Information", style: subHeader)),
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
                  style: detailBold),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Gender: ", style: detail),
              TextSpan(text: profile.gender.name, style: detailBold),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Fall History: ", style: detail),
              TextSpan(
                  text: FormatUtil.castValue(
                          jsonDecode(assessment.extra)['fall history'],
                          FallHistory.NONE)
                      .name,
                  style: detailBold),
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
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Number of Conditions: ", style: detail),
              TextSpan(
                  text: assessment.stages?.length.toString() ?? "0",
                  style: detailBold),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Number of Trials: ", style: detail),
              TextSpan(
                  text: assessment.stages
                          ?.fold<int>(0,
                              (sum, stage) => sum + (stage.trials?.length ?? 0))
                          .toString() ??
                      "0",
                  style: detailBold),
            ]),
          ),
        ]),
      ]),
      SizedBox(height: 10),
      RichText(
          textAlign: TextAlign.left,
          text: TextSpan(text: "Detection Parameters", style: subHeader)),
      Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Offset: ", style: detail),
              TextSpan(text: params.offset.toString(), style: detailBold),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Sensitivity: ", style: detail),
              TextSpan(text: params.sensitivity.toString(), style: detailBold),
            ]),
          ),
        ]),
        Spacer(),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Device Stabilized: ", style: detail),
              TextSpan(
                  text: params.deviceCorrection ? "Enabled" : "Disabled",
                  style: detailBold),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Data Stored: ", style: detail),
              TextSpan(
                  text: (jsonDecode(assessment.extra)['store data'] == true ||
                          jsonDecode(assessment.extra)['store data'] == "true")
                      ? "Yes"
                      : "No",
                  style: detailBold),
            ]),
          ),
        ]),
      ]),
    ]);
  }

//TODO: Make the bars wider to get the bar labels to fit better
  Widget assessmentData(List<List<double>> scores, List<Norm>? norms) {
    final trialsCount = scores[0].length;
    // Set the margins based on the number of trials
    final margins = trialsCount == 1
        ? [30.0, 30.0]
        : trialsCount == 2
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

    final compositeScore =
        scores.expand((stage) => stage).reduce((a, b) => a + b) /
            (scores.expand((stage) => stage).length);

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
              // Add a horizontal line at y = 75 using the dartpdf API

              // Background chart for norm scores (gray background)
              Chart(
                grid: CartesianGrid(
                  xAxis: FixedAxis.fromStrings(
                    List.generate(
                      scores.length + 1,
                      (i) => i < ctsib.stages ? 'C${i + 1}' : 'Composite',
                    ),
                    textStyle: TextStyle(fontSize: 10, font: baseFont),
                    marginStart: 30,
                    marginEnd: 30,
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
                datasets: List.generate((scores.length + 1), (i) {
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
              // 75% performance line
              Positioned(
                bottom: 220 * 0.69725, // the closest to y = 75%
                left: 30,
                right: 0,
                child: Container(
                  height: 2,
                  color: PdfColors.blue,
                ),
              ),
              // Foreground chart for patient scores
              ...List.generate(
                (scores.length),
                (i) {
                  return Chart(
                    grid: CartesianGrid(
                      xAxis: FixedAxis.fromStrings(
                        List.generate(
                          scores.length + 1,
                          (i) => '\n',
                        ),
                        textStyle: TextStyle(fontSize: 10, font: baseFont),
                        marginStart: margins[0],
                        marginEnd: margins[1],
                      ),
                      yAxis: FixedAxis(
                        [0, 25, 50, 75, 100],
                        format: (v) => '$v',
                        marginStart: 1,
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
                              fontSize: trialsCount == 1 ? 10 : 8,
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
                      scores.length + 1,
                      (i) => i < ctsib.stages ? 'C${i + 1}' : 'Composite',
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
                      PointChartValue(scores.length.toDouble(), compositeScore)
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

  Widget sensoryMismatchData(List<List<double>> scores, List<Norm>? norms) {
    // Function to calculate severity score based on the equilibrium score
    List<int> calculateSeverityScore(List<List<double>> equilibriumScores) {
      List<int> severityScores = List.filled(equilibriumScores.length, 0);
      for (int i = 0; i < equilibriumScores.length; i++) {
        final stageScores = equilibriumScores[i];
        final averageScore =
            stageScores.reduce((a, b) => a + b) / stageScores.length;
        final normScore =
            (norms?[i].scoreSum ?? 0) / ((norms?[i].trialSum ?? 1));

        // Determine the severity score based on the average score and normative data
        // Ref: https://github.com/VisualPT/visualPT/issues/243
        if (averageScore >= 75 && averageScore >= normScore) {
          severityScores[i] = 3; // 75-100 range
        } else if (averageScore >= (i < 4 ? 50 : normScore)) {
          severityScores[i] = 2; // 50-74 range or >= normScore
        } else if (averageScore >= (i < 4 ? 25 : 0)) {
          severityScores[i] = 1; // 25-49 range or 0-49 range
        } else {
          severityScores[i] = 0; // 0-24 range
        }
      }
      return severityScores;
    }

    // Function to calculate the sensory ratio and format it as a string
    String calculateSensoryRatio(List<int> severityScores) {
      String c2 = severityScores[1] == 3 ? 'S' : 'V'; // Condition 2 (SOM)
      String c3 = severityScores[2] == 3 ? 'S' : 'V'; // Condition 3 (SOM)
      String c4 = severityScores[3] == 3 ? 'V' : 'S'; // Condition 4 (VIS)

      String classifyC5C6(List<double> trialScores, double normScore) {
        int belowMean = trialScores.where((score) => score < normScore).length;
        int aboveMean = trialScores.where((score) => score >= normScore).length;
        int belowPerfLine = trialScores.where((score) => score < 75).length;

        if (aboveMean == trialScores.length && belowPerfLine == 0) {
          return 'Vest'; // All above mean and above performance line
        } else if (aboveMean == trialScores.length && belowPerfLine > 0) {
          return 'S'; // All above mean but some below 75%
        } else if (belowMean >= 2) {
          return 'V'; // Two or more below mean
        } else if (aboveMean >= 2) {
          return 'S'; // Two or more above mean
        } else {
          return 'V'; // Fallback
        }
      }

      String c5 = classifyC5C6(
          scores[4], (norms?[4].scoreSum ?? 0) / ((norms?[4].trialSum ?? 1)));
      String c6 = classifyC5C6(
          scores[5], (norms?[5].scoreSum ?? 0) / ((norms?[5].trialSum ?? 1)));

      String sensoryString = "$c2$c3$c4$c5$c6";
      return sensoryString;
    }

    String determineSensoryMismatch(
        String sensoryString, double compositeScore) {
      const double cutoff = 48.0;

      // Define base mismatch mapping
      Map<String, String> sensoryMappings = {
        "VVVVV": "VVM",
        "VVVVS": "VVM",
        "VVVSS": "VVM",
        "VSVSV": "VVM",
        "VVVSV": "VVM",
        "SVVVV": "VSVM",
        "SSSSS": "SVM",
        "SVSVS": "SVM",
        "SSSSV": "SVM",
        "VSSSS": "SVM",
        "SVSSS": "SVM",
        "SSSVV": "SVVM",
        "VVSSS": "SVVM",
        "SSVSS": "Vh-SOM",
        "SSVSV": "Vh-SOM",
        "SSVVS": "Vh-SOM",
        "SSVVV": "Vh-VIS",
        "SSVVestV": "Vh-VIS",
        "SSVVVest": "Vh-VIS",
        "VVSSV": "Vh-VIS",
        "SSSVS": "SVM",
      };

      // Get the base mismatch type
      String? baseMismatch = sensoryMappings[sensoryString];

      // If it's unknown and compositeScore is low, it's SVVM or Complex
      if (baseMismatch == null) {
        return compositeScore < cutoff ? "SVVM or Complex SM" : "Normal";
      }

      // Composite score determines severity classification
      if (compositeScore < cutoff) {
        if (baseMismatch == "VVM" ||
            baseMismatch == "SVM" ||
            baseMismatch == "VSVM") {
          return "$baseMismatch (Aphysiological?)";
        } else {
          return baseMismatch; // Already severe enough (e.g., SVVM, Vh-SOM)
        }
      } else {
        return baseMismatch; // Composite is good, use base label
      }
    }

    // Function to calculate the sensory ratio and format it as a color-coded string (Red/Blue)
    TextSpan colorizeSensoryString(List<int> severityScores) {
      // Colors: Red for abnormal scores (visual/somatosensory), Blue for vestibular function
      PdfColor redColor =
          const PdfColor.fromInt(0xFF0000); // Red for VIS/SOM abnormalities
      PdfColor blueColor =
          const PdfColor.fromInt(0x0000FF); // Blue for VEST normal function

      // Map severity scores to sensory systems and assign appropriate colors
      String c2 = severityScores[1] == 3 ? 'S' : 'V'; // Condition 2 (SOM)
      String c3 = severityScores[2] == 3 ? 'S' : 'V'; // Condition 3 (SOM)
      String c4 = severityScores[3] == 3 ? 'V' : 'S'; // Condition 4 (VIS)
      String c5 = severityScores[4] == 3
          ? 'Vest'
          : severityScores[4] == 2
              ? 'S'
              : 'V'; // Condition 5 (VEST abnormal)
      String c6 = severityScores[5] == 3
          ? 'Vest'
          : severityScores[5] == 2
              ? 'S'
              : 'V'; // Condition 6 (VEST abnormal)

      String sensoryString = "$c2$c3$c4$c5$c6";

      // Count occurrences of 'S' and 'V'
      int sCount = sensoryString.split('S').length - 1; // Count 'S'
      int vCount = sensoryString.split('V').length - 1; // Count 'V'
      // Format the final sensory ratio
      String sensoryRatio = sCount > vCount
          ? "(${sCount}S:${vCount}V)"
          : "(${vCount}V:${sCount}S)";

      return TextSpan(
        children: [
          TextSpan(
            text: c2,
            style: TextStyle(
                color: c2 == 'S' ? blueColor : redColor,
                font: boldFont,
                fontSize: 12.0,
                lineSpacing: 2.0),
          ),
          TextSpan(
            text: c3,
            style: TextStyle(
                color: c3 == 'S' ? blueColor : redColor,
                font: boldFont,
                fontSize: 12.0,
                lineSpacing: 2.0),
          ),
          TextSpan(
            text: c4,
            style: TextStyle(
                color: c4 == 'V' ? blueColor : redColor,
                font: boldFont,
                fontSize: 12.0,
                lineSpacing: 2.0),
          ),
          TextSpan(
            text: c5,
            style: TextStyle(
                color: c5 == 'Vest' ? blueColor : redColor,
                font: boldFont,
                fontSize: 12.0,
                lineSpacing: 2.0),
          ),
          TextSpan(
            text: c6,
            style: TextStyle(
                color: c6 == 'Vest' ? blueColor : redColor,
                font: boldFont,
                fontSize: 12.0,
                lineSpacing: 2.0),
          ),
          TextSpan(text: " ", style: detail),
          TextSpan(
            text: sensoryRatio,
            style: detailBold,
          )
        ],
      );
    }

    final severityScores = calculateSeverityScore(scores);

    final compositeScore =
        scores.expand((stage) => stage).reduce((a, b) => a + b) /
            (scores.expand((stage) => stage).length);
    final sensoryRatio = calculateSensoryRatio(severityScores);
    final sensoryMismatch =
        determineSensoryMismatch(sensoryRatio, compositeScore);

    // Display the sensory ratio and mismatch in a table format
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
        textAlign: TextAlign.left,
        text: TextSpan(text: "Sensory Ratios & Mismatch", style: subHeader),
      ),
      Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Severity Scores: ", style: detail),
              TextSpan(text: severityScores.toString(), style: detailBold),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Composite Score: ", style: detail),
              TextSpan(text: compositeScore.toString(), style: detailBold),
            ]),
          ),
        ]),
        Spacer(),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(text: 'Sensory Ratio: ', style: detail),
              colorizeSensoryString(severityScores),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Sensory Mismatch: ", style: detail),
              TextSpan(text: sensoryMismatch, style: detailBold),
            ]),
          ),
        ])
      ])
    ]);
  }

  //TODO: Add normative data, and potientally another data field for collecting the patients fall history
  // Widget normativeData(Assessment assessment, List<Norm>? norms,
  //     {DetectionParams params = const DetectionParams()}) {
  //   final message =
  //       ctsib.getNormativeMessage(assessment, norms, params: params);

  //   return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //     RichText(
  //         textAlign: TextAlign.left,
  //         text: TextSpan(text: "Normative Comparison", style: subHeader)),
  //     RichText(text: TextSpan(text: message, style: detail)),
  //   ]);
  // }

  // Widget interpretationData(Assessment assessment) {
  //   return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //     RichText(
  //         textAlign: TextAlign.left,
  //         text: TextSpan(text: "Interpretation", style: subHeader)),
  //     // if (is9xFallRisk)
  //     //   RichText(
  //     //     textAlign: TextAlign.left,
  //     //     text: TextSpan(
  //     //         text:
  //     //             "Patient displays deficits on Condition 5 and Condition 6 of the CTSIB which puts them at high risk (9x more likely) for a fall over the next 30 days.",
  //     //         style: detail),
  //     //   ),
  //     RichText(
  //         text: TextSpan(
  //             text: "Generative AI snippets coming soon", style: detail)),
  //     //generateConditionRatioText(assessment), style: detail)),
  //     //             "1)	Vision Dependence: Patients become unstable in stages 2, 3, 5 & 6 with eyes closed.",
  //     //             "2) Surface/somatosensory dependence: Patient becomes unstable in stages 4, 5 & 6 because they stand on a soft surface (foam).",
  //     //             "3)	Vestibular loss: Patient becomes unstable in stages 5 & 6 because they can't rely on vision or surface / somatosensory function.",
  //     //             "4)	Patients with sensory selection problems become unstable in stages 3-6.",
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
    );
  }

  String determineStatus(double ratio) {
    if (ratio == 0.0) {
      return "Inconclusive"; // Ratio is 0.0, indicating an invalid or uncalculable result
    } else if (ratio < 99) {
      return "Dysfunctional"; // Patient is dysfunctional if the ratio is less than 1
    } else {
      return "Functional"; // Patient is considered functional otherwise
    }
  }
}
