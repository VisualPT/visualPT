import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:visualpt/models/ModelProvider.dart';

abstract class PDF {
  late Font baseFont;
  late Font boldFont;
  late Font italicFont;
  late Font boldItalicFont;

  late PdfColor primaryColor;
  late PdfColor secondaryColor;
  late PdfColor black;

  late BorderSide borderSide;

  final double inch = 72.0;
  final double halfinch = 36.0;

  late TextStyle header;
  late TextStyle headerItalic;
  late TextStyle subTitle;
  late TextStyle detail;
  late TextStyle detailBold;
  late TextStyle subHeader;
  late TextStyle disclaimer;

  Future<void> configPdfStyles() async {
    baseFont = await PdfGoogleFonts.openSansRegular();
    boldFont = await PdfGoogleFonts.openSansBold();
    italicFont = await PdfGoogleFonts.openSansItalic();
    boldItalicFont = await PdfGoogleFonts.openSansBoldItalic();

    primaryColor = PdfColor.fromHex('#008ed6');
    secondaryColor = PdfColor.fromHex('#24446c');
    black = PdfColors.black;

    borderSide = BorderSide(width: 2, color: secondaryColor);

    header = TextStyle(font: boldFont, fontSize: 30.0, lineSpacing: 2.0);
    headerItalic =
        TextStyle(font: boldItalicFont, fontSize: 30.0, lineSpacing: 2.0);
    subTitle = TextStyle(font: boldFont, fontSize: 20.0, lineSpacing: 2.0);
    detail = TextStyle(font: baseFont, fontSize: 15.0, lineSpacing: 2.0);
    detailBold = TextStyle(font: boldFont, fontSize: 15.0, lineSpacing: 2.0);
    subHeader = TextStyle(font: boldFont, fontSize: 50.0, lineSpacing: 2.0);
    disclaimer = TextStyle(font: baseFont, fontSize: 10.0, lineSpacing: 2.0);
    return;
  }

  Future<Uint8List> generatePdf(Patient patient, Assessment assessment);
}
