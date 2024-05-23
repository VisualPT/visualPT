import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:visualpt/models/ModelProvider.dart';

abstract class PDF {
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
    invisible =
        TextStyle(fontSize: 10.0, lineSpacing: 20.0, color: transparent);

    RichTextLogo = RichText(
        text: TextSpan(children: [
      TextSpan(text: 'Visual', style: logoVisual),
      TextSpan(text: 'PT', style: logoPT)
    ]));
    return;
  }

  Future<Uint8List> generatePdf(Subject subject, Assessment assessment);
}
