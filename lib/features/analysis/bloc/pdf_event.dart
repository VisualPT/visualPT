part of 'pdf_bloc.dart';

abstract class PdfEvent extends Equatable {
  const PdfEvent();

  @override
  List<Object> get props => [];
}

class PdfInit extends PdfEvent {
  final Subject subject;
  final Assessment assessment;

  const PdfInit({required this.subject, required this.assessment});

  @override
  List<Object> get props => [subject, assessment];
}
