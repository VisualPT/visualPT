part of 'pdf_bloc.dart';

@immutable
abstract class PdfState {}

class PdfLoading extends PdfState {}

class PdfReady extends PdfState {
  final Uint8List pdfData;
  final Subject subject;
  final Assessment assessment;
  PdfReady(
      {required this.pdfData, required this.subject, required this.assessment});
}

class PdfError extends PdfState {
  final Exception exception;
  PdfError({required this.exception});
}
