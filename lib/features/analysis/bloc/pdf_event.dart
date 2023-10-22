part of 'pdf_bloc.dart';

abstract class PdfEvent extends Equatable {
  const PdfEvent();

  @override
  List<Object> get props => [];
}

class PdfInit extends PdfEvent {
  final Patient patient;
  final Assessment assessment;

  const PdfInit({required this.patient, required this.assessment});

  @override
  List<Object> get props => [patient, assessment];
}
