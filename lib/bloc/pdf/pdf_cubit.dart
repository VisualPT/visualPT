import 'dart:developer';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/assessments/ctsib/pdf.dart';
import 'package:visualpt/views/assessments/gait/_gait.dart';

part 'pdf_state.dart';

///TODO BUGGGY CODE
class PdfCubit extends Cubit<PdfState> {
  PdfCubit() : super(PdfLoading());
  bool viewCreated = false;

  void initPDFView(Patient patient, Assessment assessment) async {
    var document;
    emit(PdfLoading());
    switch (assessment.type) {
      case AssessmentType.CTSIB:
        document = CtsibPDF();
        break;
      case AssessmentType.GAIT:
        document = GaitPDF();

        break;
      default:
    }
    try {
      await document
          .configPdfStyles()
          .then((_) => document.generatePdf(patient, assessment))
          .then((pdfData) {
        PDFView view = PDFView(
            enableSwipe: false,
            pdfData: pdfData,
            pageFling: false,
            onError: (error) => emit(PdfError(exception: error)),
            onPageError: (page, error) => emit(PdfError(exception: error)),
            pageSnap: false);
        emit(PdfLoaded(pdfView: view));
      });
    } on Exception catch (error) {
      emit(PdfError(exception: error));
    } catch (e) {
      log(e.toString());
    }
  }
}
