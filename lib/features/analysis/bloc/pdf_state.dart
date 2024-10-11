part of 'pdf_bloc.dart';

@immutable
abstract class PdfState extends Equatable {
  const PdfState();

  @override
  List<Object> get props => [];
}

class PdfLoading extends PdfState {
  const PdfLoading();

  @override
  List<Object> get props => [];
}

class PdfReady extends PdfState {
  final Uint8List pdfData;
  final Subject subject;
  final Assessment assessment;
  const PdfReady(
      {required this.pdfData, required this.subject, required this.assessment});

  @override
  List<Object> get props => [pdfData, subject, assessment];
}

class PdfError extends PdfState {
  final Exception exception;
  const PdfError({required this.exception});

  @override
  List<Object> get props => [exception];
}
