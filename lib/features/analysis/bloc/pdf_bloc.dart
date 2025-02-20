import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/models/ModelProvider.dart';

part 'pdf_event.dart';
part 'pdf_state.dart';

class PdfBloc extends Bloc<PdfEvent, PdfState> {
  PdfBloc() : super(const PdfLoading()) {
    on<PdfInit>(_onInit);
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
          .then((_) => document.generatePdf(event.profile, event.assessment))
          .then((pdfData) {
        emit(PdfReady(
            pdfData: pdfData,
            profile: event.profile,
            assessment: event.assessment));
      });
    } on Exception catch (error) {
      log(error.toString(), name: 'PDF Error');
      emit(PdfError(exception: error));
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace, name: 'PDF Error');
      emit(PdfError(exception: Exception(e.toString())));
    }
  }
}
