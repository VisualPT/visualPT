import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:visualpt/core/views/styles.dart';
import 'package:visualpt/features/assessment/service/assessment_utils.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/assessment/config/_pdf.dart';
import 'package:visualpt/features/assessment/config/ctsib/ctsib.dart';

class CtsibPDF extends PDF {
  final ctsib = CTSIB();
  @override
  Future<Uint8List> generatePdf(Subject subject, Assessment assessment) async {
    await configPdfStyles();

    final norms = await ctsib.getNorms(subject.dob, subject.gender);

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
            assessmentData(subject, assessment, norms),
            Spacer(),
            sensoryMismatchData(assessment),
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
                  style: detailBold),
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

  Widget assessmentData(
      Subject subject, Assessment assessment, List<Norm>? norms) {
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
                    List.generate(((assessment.Conditions?.length ?? 0) + 1),
                        (i) => '\n\n'),
                    textStyle: const TextStyle(fontSize: 10),
                    marginStart: 30,
                    marginEnd: 30,
                  ),
                  yAxis: FixedAxis(
                    [0, 25, 50, 75, 100],
                    format: (v) => '$v',
                    marginStart: 1,
                  ),
                ),
                datasets: List.generate(
                    ((assessment.Conditions?.length ?? 0) + 1), (i) {
                  return BarDataSet(
                    legend: '',
                    color: PdfColors.grey, // Normative background
                    data: [
                      PointChartValue(
                          (i).toDouble(),
                          (norms?[i].score_sum ?? 0) /
                              ((norms?[i].trial_sum ?? 1)))
                    ],
                    valuePosition: ValuePosition.auto,
                    width: 30,
                  );
                }),
              ),
              // Foreground chart for patient scores
              Chart(
                grid: CartesianGrid(
                  xAxis: FixedAxis.fromStrings(
                    List.generate(
                      ((assessment.Conditions?.length ?? 0) + 1),
                      (i) => (assessment.Conditions?.length ?? 0) != i
                          ? '${ctsib.vision[i]}\n${ctsib.surface[i]}'
                          : 'Cumulative',
                    ),
                    textStyle: const TextStyle(fontSize: 10),
                    marginStart: 30,
                    marginEnd: 30,
                  ),
                  yAxis: FixedAxis(
                    [0, 25, 50, 75, 100],
                    format: (v) => '$v',
                    marginStart: 1,
                    divisions: true,
                    divisionsColor: PdfColor.fromInt(Styles.activeOrange.value),
                  ),
                ),
                datasets: List.generate(
                    ((assessment.Conditions?.length ?? 0) + 1), (i) {
                  if ((assessment.Conditions?.length ?? 0) != i) {
                    //TODO: Add multiple trials here
                    return BarDataSet(
                      legend: '${ctsib.vision[i]}\n${ctsib.surface[i]}',
                      color: ctsib.calculateScores(assessment)[i] >
                              (norms?[i].score_sum ?? 0) /
                                  ((norms?[i].trial_sum ?? 1))
                          ? PdfColors.green
                          : PdfColors.red, // Patient data color
                      width: 20,
                      data: [
                        PointChartValue(
                          (i).toDouble(),
                          ctsib.calculateScores(assessment)[i],
                        ),
                      ],
                      buildValue: (context, point) => Text(
                          //If this is flagged as a fall, write FALL
                          point.y == 0 ? "FALL" : point.y.toStringAsFixed(2),
                          style: const TextStyle(fontSize: 10)),
                      valuePosition: ValuePosition.auto,
                    );
                  }
                  return BarDataSet(
                    legend: '#${i + 1}',
                    color: (ctsib.calculateScores(assessment).fold<double>(0.0,
                                    (prevScore, score) => prevScore + score) /
                                i) >
                            (norms?[i].score_sum ?? 0) /
                                ((norms?[i].trial_sum ?? 1))
                        ? PdfColors.green
                        : PdfColors.red, // Patient data color
                    width: 20,
                    data: [
                      PointChartValue(
                        (i).toDouble(),
                        ctsib.calculateScores(assessment).fold<double>(
                                0.0, (prevScore, score) => prevScore + score) /
                            i,
                      ),
                    ],
                    buildValue: (context, point) => Text(
                        //If this is flagged as a fall, write FALL
                        point.y == 0 ? "FALL" : point.y.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 10)),
                    valuePosition: ValuePosition.auto,
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget sensoryMismatchData(Assessment assessment) {
    // Function to calculate severity score based on the equilibrium score
    List<int> calculateSeverityScore(List<double> equilibriumScore) {
      List<int> severityScores = List.filled(equilibriumScore.length, 0);
      for (int i = 0; i < equilibriumScore.length; i++) {
        if (equilibriumScore[i] >= 75) {
          severityScores[i] = 3; // 75-100 range
        } else if (equilibriumScore[i] >= 50) {
          severityScores[i] = 2; // 50-74 range
        } else if (equilibriumScore[i] >= 25) {
          severityScores[i] = 1; // 25-49 range
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
      String c5 = severityScores[4] == 3
          ? 'Vest'
          : severityScores[4] == 2
              ? 'S'
              : 'V';
      String c6 = severityScores[5] == 3
          ? 'Vest'
          : severityScores[5] == 2
              ? 'S'
              : 'V';

      String sensoryString = "$c2$c3$c4$c5$c6";
      return sensoryString;
    }

    // Function to determine the sensory mismatch and check for Aphysio
    // Function to determine the sensory mismatch based on sensoryString
    String determineSensoryMismatch(String sensoryString, int compositeScore) {
      // Direct mapping of sensoryString patterns to sensory mismatch categories
      Map<String, String> sensoryMappings = {
        //TODO: have a PT review these, the color codings of these actually matter
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

      // Check if the sensoryString matches any known mappings
      if (sensoryMappings.containsKey(sensoryString)) {
        return sensoryMappings[sensoryString]!;
      }

// Apply age-group thresholds based on the composite score
      if (compositeScore >= 12) {
        return sensoryMappings[sensoryString] ?? "Normal";
      } else {
        return "SVVM or Complex SM"; // Complex SM for lower scores
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
      int vCount = sensoryString.split('V').length -
          1 +
          (c5 == "Vest" ? 1 : 0) +
          (c6 == "Vest" ? 1 : 0); // Count 'V'
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
          const TextSpan(text: " "),
          TextSpan(
            text: sensoryRatio,
            style: detailBold,
          )
        ],
      );
    }

    final scores = ctsib.calculateScores(assessment);
    final severityScores = calculateSeverityScore(scores);
    final compositeScore =
        severityScores.fold<int>(0, (prev, cur) => prev + cur);
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
  Widget normativeData(Assessment assessment, List<Norm>? norms) {
    final message = ctsib.getNormativeMessage(assessment, norms);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
          textAlign: TextAlign.left,
          text: TextSpan(text: "Normative Comparison", style: subHeader)),
      RichText(text: TextSpan(text: message, style: detail)),
    ]);
  }

  Widget interpretationData(Assessment assessment) {
    // final is9xFallRisk = checkFallRisk(assessment);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
          textAlign: TextAlign.left,
          text: TextSpan(text: "Interpretation", style: subHeader)),
      // if (is9xFallRisk)
      //   RichText(
      //     textAlign: TextAlign.left,
      //     text: TextSpan(
      //         text:
      //             "Patient displays deficits on Condition 5 and Condition 6 of the CTSIB which puts them at high risk (9x more likely) for a fall over the next 30 days.",
      //         style: detail),
      //   ),
      RichText(
          text: TextSpan(
              text: "Generative AI snippets coming soon", style: detail)),
      //generateConditionRatioText(assessment), style: detail)),
      //             "1)	Vision Dependence: Patients become unstable in conditions 2, 3, 5 & 6 with eyes closed.",
      //             "2) Surface/somatosensory dependence: Patient becomes unstable in conditions 4, 5 & 6 because they stand on a soft surface (foam).",
      //             "3)	Vestibular loss: Patient becomes unstable in conditions 5 & 6 because they can't rely on vision or surface / somatosensory function.",
      //             "4)	Patients with sensory selection problems become unstable in conditions 3-6.",
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

  //TODO: This likely needs to be based on the equlibrium score
  bool checkFallRisk(Assessment assessment) {
    // Calculate the total duration of the assessment (only for conditions 5 and 6)
    bool is9xFallRisk(int i) {
      final total =
          AssessmentUtils.getAvgDuration(assessment.Conditions?[i].trials) >
              30.0;
      return total;
    }

    // Determine if the patient is at risk of falling based on the total duration
    return is9xFallRisk(4) || is9xFallRisk(5);
  }

  // String generateConditionRatioText(Assessment assessment) {
  //   final scores = CTSIB().calculateScores(assessment);

  //   // Calculating ratios safely
  //   final somRatio = safeDivision(scores[1], scores[0]);
  //   final visRatio = safeDivision(scores[3], scores[0]);
  //   final vestRatio = safeDivision(scores[4], scores[0]);

  //   final ratios = [
  //     (
  //       vestRatio,
  //       "Patient demonstrates a ${vestRatio.toStringAsFixed(2)}% ratio on the vestibular function test which puts them in the dysfunctional category."
  //     ),
  //     (
  //       visRatio,
  //       "Patient demonstrates a ${visRatio.toStringAsFixed(2)}% ratio on the visual dependence test which puts them in the dysfunctional category."
  //     ),
  //     (
  //       somRatio,
  //       "Patient demonstrates a ${somRatio.toStringAsFixed(2)}% ratio on the somatic sensory function test which puts them in the dysfunctional category."
  //     ),
  //   ];

  //   // Determine the worst ratio among the three
  //   final lowest = ratios.reduce((a, b) => a.$1 < b.$1 ? a : b);

  //   if (lowest.$1 > 99) {
  //     return "No significant findings were observed.";
  //   }

  //   return lowest.$2;
  // }
}
