part of 'pdf_bloc.dart';

@immutable
abstract class PdfState {}

class PdfLoading extends PdfState {}

class PdfLoaded extends PdfState {
  final PDFView pdfView;
  final Patient patient;
  final Assessment assessment;
  PdfLoaded(
      {required this.pdfView, required this.patient, required this.assessment});
}

class PdfError extends PdfState {
  final Exception exception;
  PdfError({required this.exception});
}
