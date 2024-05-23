import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/assessment/config/ctsib/pdf.dart';
import 'package:visualpt/features/assessment/config/gait/pdf.dart';
import 'package:visualpt/features/assessment/config/_pdf.dart';

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
          .then((_) => document.generatePdf(event.subject, event.assessment))
          .then((pdfData) {
        emit(PdfReady(
            pdfData: pdfData,
            subject: event.subject,
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
