import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:visualpt/features/assessment/config/ctsib_collect/ctsib_collect.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/assessment/config/_pdf.dart';

class CtsibCollectPDF extends PDF {
  final ctsib = CTSIB_COLLECT();
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
            thankYou(),
            Spacer(),
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

  Widget thankYou() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
          textAlign: TextAlign.left,
          text: TextSpan(text: "Thank You", style: subHeader)),
      RichText(
          text: TextSpan(
              text:
                  "Thank you for collecting CTSIB data for VisualPT.AI, this data will make the pose classification model better for screening patients with real risks. If you have any questions or concerns, please contact VisualPT.AI support.",
              style: detail)),
    ]);
  }
}
