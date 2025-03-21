import 'dart:typed_data';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:visualpt/features/assessment/bloc/assessment_bloc.dart';
import 'package:visualpt/features/assessment/types.dart';
import 'package:visualpt/models/ModelProvider.dart';

/// The parameters that start with [seq] are used to define the individual sequences
/// the length of the Lists should be equal to the [stages] parameter
abstract class BaseAssessment {
  AssessmentType get type;
  String get name;
  String get normalDuration;
  String get details;
  String get imagePath;
  String? get stageGifPath;

  int get stages;
  int get trials;
  int get trialDuration;
  List<String> get stageNames;
  List<List<String>> get stageInstructions;
  List<bool> get stageObtrusion;
  List<bool> get stageInstability;

  /// key must equal the key in the formFields and in the expected extra metadata
  /// value in the form field may need to be transformed with valueTransform in the form field
  /// ex. enumerations, dates, etc. so they can be properly parsed and stored
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

TrialMeta getMeta(
  BaseAssessment config,
  Profile profile,
  AssessmentEvent event,
  int stageIndex,
  int trialIndex,
) {
  final trials =
      int.tryParse(event.formFields['trial count']?.value) ?? config.trials;
  final trialDuration =
      int.tryParse(event.formFields['trial duration']?.value) ??
          config.trialDuration;
  final store = bool.tryParse(event.formFields['store data']?.value) ?? true;

  return TrialMeta(
      profile.dob.toString(),
      profile.gender,
      config.type,
      config.stageObtrusion[stageIndex],
      config.stageInstability[stageIndex],
      stageIndex,
      trialIndex,
      trials,
      trialDuration,
      store);
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
}

class FormFieldItem<T> {
  final FormBuilderField<T> form;
  final T value;

  FormFieldItem({
    required this.form,
    required this.value,
  });
}
