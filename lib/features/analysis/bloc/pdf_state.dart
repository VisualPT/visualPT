part of 'pdf_bloc.dart';

@immutable
abstract class PdfState {}

class PdfLoading extends PdfState {}

class PdfReady extends PdfState {
  final PDFView pdfView;
  final Subject subject;
  final Assessment assessment;
  PdfReady(
      {required this.pdfView, required this.subject, required this.assessment});
}

class PdfError extends PdfState {
  final Exception exception;
  PdfError({required this.exception});
}
