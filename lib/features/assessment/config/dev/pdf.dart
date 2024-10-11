import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:visualpt/features/assessment/config/_pdf.dart';
import 'package:visualpt/models/ModelProvider.dart';

const halfinch = 36.0;
const inch = 72.0;
const height = 11 * inch;
const width = 8.5 * inch;

class DevPDF extends PDF {
  @override
  Future<Uint8List> generatePdf(Subject subject, Assessment assessment) async {
    try {
      final pdf = Document(title: "Test", creator: "VisualPT Systems");

      pdf.addPage(
        Page(
          pageTheme: const PageTheme(
            pageFormat: PdfPageFormat.letter,
            margin: EdgeInsets.all(halfinch),
          ),
          build: (Context context) =>
              SizedBox(height: height, width: width, child: Text("Test")),
        ),
      );
      final data = pdf.save();
      return data;
    } on Exception catch (error) {
      throw Exception('Error generating PDF: $error');
    }
  }
}
