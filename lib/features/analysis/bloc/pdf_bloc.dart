import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/models/ModelProvider.dart';

part 'pdf_event.dart';
part 'pdf_state.dart';

class PdfBloc extends Bloc<PdfEvent, PdfState> {
  PdfBloc() : super(const PdfLoading()) {
    on<PdfInit>(_onInit);
    on<PdfPrint>(_onPrint);
  }

  FutureOr<void> _onInit(PdfInit event, Emitter<PdfState> emit) async {
    late BasePDF document;
    emit(const PdfLoading());
    switch (event.assessment.type) {
      case AssessmentType.CTSIB:
        document = CtsibPDF();
        break;
      case AssessmentType.GAIT:
        document = GaitPDF();
        break;
      case AssessmentType.MCTSIB:
        document = MctsibPDF();
        break;
      case AssessmentType.DEV:
        document = DevPDF();
      default:
        throw Exception(
            'Invalid Assessment Type, Cannot Generate PDF for ${event.assessment.type}');
    }
    try {
      await document
          .configPdfStyles()
          .then((_) => document.generatePdf(
              event.profile, event.assessment, event.params))
          .then((pdfData) {
        emit(PdfReady(
            pdfData: pdfData,
            profile: event.profile,
            assessment: event.assessment));
      });
    } on Exception catch (error, stackTrace) {
      log(error.toString(), name: 'PDF Error');
      emit(PdfError(exception: error, stackTrace: stackTrace));
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace, name: 'PDF Error');
      emit(
          PdfError(exception: Exception(e.toString()), stackTrace: stackTrace));
    }
  }

  FutureOr<void> _onPrint(PdfPrint event, Emitter<PdfState> emit) async {
    try {
      // TODO: Blocked by https://github.com/DavBfr/dart_pdf/issues/1638
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          return event.pdfData; // raw Uint8List data passed from `PdfReady`
        },
      );
    } on Exception catch (error, stackTrace) {
      log(error.toString(), name: 'PDF Print Error');
      emit(PdfError(exception: error, stackTrace: stackTrace));
    }
  }
}
