import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:visualpt/core/utils/format.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/features/capture/service/pose_landmarks.dart';
import 'package:visualpt/models/ModelProvider.dart';

const halfinch = 36.0;
const inch = 72.0;
const height = 11 * inch;
const width = 8.5 * inch;

class DevPDF extends BasePDF {
  final dev = DEV();

  @override
  Future<Uint8List> generatePdf(Profile profile, Assessment assessment,
      Map<String, dynamic> params) async {
    try {
      final pdf = Document(title: "Test", creator: "VisualPT Systems");

      pdf.addPage(
        Page(
          pageTheme: const PageTheme(
            pageFormat: PdfPageFormat.letter,
            margin: EdgeInsets.all(halfinch),
          ),
          build: (Context context) => SizedBox(
            height: height,
            width: width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              headerData(),
              subjectData(profile, assessment),
              Spacer(),
              detectionData(profile, assessment),
              Spacer(),
              footerData(),
            ]),
          ),
        ),
      );
      final data = pdf.save();
      return data;
    } on Exception catch (error) {
      throw Exception('Error generating PDF: $error');
    }
  }

  Widget headerData() {
    return Header(
      child: Column(
        children: [
          RichTextLogo,
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(text: "${dev.name} Report", style: header),
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
                  style: detailBold),
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
          //TODO internationalize this date format to local time
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

  Widget detectionData(Profile profile, Assessment assessment) {
    final keypoints = PoseLandmarks.decodeCompressed(
        assessment.stages!.first.trials!.first.compressedDetections);
    //Go through each keypoint and calculate the angle
    //using computeAngles(detection), and return the xy and yz sways from each of those
    // responses as an average of all of them put together
    // final averageSway = keypoints
    //     .map((keypoint) => PoseLandmarks.computeAngles(keypoint))
    //     .reduce((a, b) => (a.$1 + b.$1, a.$2 + b.$2));
    // final averageXY = averageSway.$1 / keypoints.length;
    // final averageYZ = averageSway.$2 / keypoints.length;

    // final averagePitch = keypoints.map((keypoint) {
    //       //use keypoint.env.accX, keypoint.env.accY, keypoint.env.accZ
    //       // to calculate the pitch
    //       final accX = keypoint.env.accX;
    //       final accY = keypoint.env.accY;
    //       final accZ = keypoint.env.accZ;
    //       final pitch =
    //           (atan2(-accX, sqrt(accY * accY + accZ * accZ)) * (180 / pi));
    //       return pitch;
    //     }).reduce((a, b) => a + b) /
    //     keypoints.length;

    // final averageYaw = keypoints.map((keypoint) {
    //       //use keypoint.env.accX, keypoint.env.accY, keypoint.env.accZ
    //       // to calculate the yaw
    //       final accX = keypoint.env.accX;
    //       final accY = keypoint.env.accY;
    //       final accZ = keypoint.env.accZ;
    //       final yaw = atan2(accZ, accY) * (180 / pi);
    //       return yaw;
    //     }).reduce((a, b) => a + b) /
    //     keypoints.length;

    // final averageSwayData = {
    //   'averageXY': averageXY,
    //   'averageYZ': averageYZ,
    //   'averagePitch': averagePitch,
    //   'averageYaw': averageYaw,
    // };

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
          textAlign: TextAlign.left,
          text: TextSpan(text: "Detection Data", style: subHeader)),
      RichText(
          textAlign: TextAlign.left,
          text: TextSpan(text: "Keypoints", style: detail)),
      RichText(
          textAlign: TextAlign.left,
          text: TextSpan(text: keypoints.toString(), style: detailBold)),
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
}
