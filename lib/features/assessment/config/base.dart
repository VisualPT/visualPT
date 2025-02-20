import 'dart:typed_data';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart' show TextEditingController;
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:visualpt/models/ModelProvider.dart';

/// The parameters that start with [seq] are used to define the individual sequences
/// the length of the Lists should be equal to the [stages] parameter
abstract class BaseAssessment {
  AssessmentType get type;
  String get name;
  String get normalDuration;
  String get details;
  String get imagePath;

  int get stages;
  int get trials;
  int get trialDuration;
  List<String> get conditionNames;
  List<List<String>> get conditionInstructions;
  List<bool> get conditionObtrusion;
  List<bool> get conditionInstability;
  Map<String, FormFieldItem> get formFields;
  bool get isTrainingData;
  bool get isAvailable;

  Future<List<Norm>?> getNorms(TemporalDate dob, Gender gender) {
    return Future.value(null);
  }

  Future<Norm?> setNorm(
      TemporalDate dob, Gender gender, int seqNum, double score, int trials) {
    return Future.value();
  }

  List<double> calculateScores(Assessment assessment) {
    return List.filled(0, 0.0);
  }

  String getNormativeMessage(Assessment assessment, List<Norm>? norms) {
    return "Default Normative Message";
  }

  // Controls video recording, if returns true, the video will stop recording
  bool isComplete(Detection? detection) {
    return false;
  }
}

abstract class BasePDF {
  //TODO Hide in a styles class
  late Font logoVisualFont;
  late Font logoPTFont;
  late Font baseFont;
  late Font boldFont;
  late Font italicFont;
  late Font boldItalicFont;

  late PdfColor primaryColor;
  late PdfColor secondaryColor;
  late PdfColor black;
  late PdfColor transparent;

  late BorderSide borderSide;

  final double inch = 72.0;
  final double halfinch = 36.0;

  late TextStyle logoVisual;
  late TextStyle logoPT;

  late TextStyle header;
  late TextStyle headerItalic;
  late TextStyle subTitle;
  late TextStyle detail;
  late TextStyle detailBold;
  late TextStyle subHeader;
  late TextStyle disclaimer;
  late TextStyle invisible;

  late RichText RichTextLogo;

  //TODO: Add a default BaseAssessment for all the PDFs to depend on

  Future<void> configPdfStyles() async {
    logoVisualFont = await PdfGoogleFonts.unboundedBold();
    logoPTFont = await PdfGoogleFonts.unboundedLight();

    baseFont = await PdfGoogleFonts.openSansRegular();
    boldFont = await PdfGoogleFonts.openSansBold();
    italicFont = await PdfGoogleFonts.openSansItalic();
    boldItalicFont = await PdfGoogleFonts.openSansBoldItalic();

    primaryColor = PdfColor.fromHex('#008ed6');
    secondaryColor = PdfColor.fromHex('#24446c');
    black = PdfColors.black;
    transparent = const PdfColor(0, 0, 0, 0);

    borderSide = BorderSide(width: 2, color: secondaryColor);

    logoVisual = TextStyle(font: logoVisualFont, fontSize: 20.0);
    logoPT = TextStyle(font: logoPTFont, fontSize: 20.0);

    header = TextStyle(font: boldFont, fontSize: 20.0, lineSpacing: 2.0);
    headerItalic =
        TextStyle(font: boldItalicFont, fontSize: 20.0, lineSpacing: 2.0);
    subTitle = TextStyle(font: boldFont, fontSize: 15.0, lineSpacing: 2.0);
    detail = TextStyle(font: baseFont, fontSize: 12.0, lineSpacing: 2.0);
    detailBold = TextStyle(font: boldFont, fontSize: 12.0, lineSpacing: 2.0);
    subHeader = TextStyle(font: boldFont, fontSize: 18.0, lineSpacing: 2.0);
    disclaimer = TextStyle(font: baseFont, fontSize: 10.0, lineSpacing: 2.0);
    invisible = TextStyle(
        font: baseFont, fontSize: 10.0, lineSpacing: 20.0, color: transparent);

    RichTextLogo = RichText(
        text: TextSpan(children: [
      TextSpan(text: 'Visual', style: logoVisual),
      TextSpan(text: 'PT', style: logoPT)
    ]));
    return;
  }

  Future<Uint8List> generatePdf(Profile profile, Assessment assessment);

  String formatTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(dateTime);
  }

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMMM dd, yyyy');
    return formatter.format(dateTime);
  }

  String formatDuration(double durationInSeconds) {
    int minutes = durationInSeconds ~/ 60;
    double remainingSeconds = durationInSeconds % 60;
    //If the duration is less than a minute, return only the seconds
    if (minutes == 0) {
      return "${remainingSeconds.round()} seconds";
    }
    return "$minutes minutes ${remainingSeconds.round()} seconds";
  }
}

class FormFieldItem {
  final FormBuilderField form;
  final TextEditingController controller;

  FormFieldItem({
    required this.form,
    required this.controller,
  });

  void clear() {
    controller.clear();
  }
}
