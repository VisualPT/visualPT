import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/assessment/view/ctsib/pdf.dart';
import 'package:visualpt/features/assessment/view/gait/_gait.dart';
import 'package:visualpt/features/assessment/view/_pdf.dart';

part 'pdf_event.dart';
part 'pdf_state.dart';

class PdfBloc extends Bloc<PdfEvent, PdfState> {
  PdfBloc() : super(PdfLoading()) {
    on<PdfInit>(_onInit);
  }

  FutureOr<void> _onInit(PdfInit event, Emitter<PdfState> emit) async {
    late PDF document;
    emit(PdfLoading());
    switch (event.assessment.type) {
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
          .then((_) => document.generatePdf(event.patient, event.assessment))
          .then((pdfData) {
        PDFView view = PDFView(
            enableSwipe: false,
            pdfData: pdfData,
            pageFling: false,
            onError: (error) => emit(PdfError(exception: error)),
            onPageError: (page, error) => emit(PdfError(exception: error)),
            pageSnap: false);
        emit(PdfReady(
            pdfView: view,
            patient: event.patient,
            assessment: event.assessment));
      });
    } on Exception catch (error) {
      emit(PdfError(exception: error));
    } catch (e) {
      log(e.toString(), name: 'PDF Error');
    }
  }

  bool viewCreated = false;
}
