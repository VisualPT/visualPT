part of 'pdf_bloc.dart';

abstract class PdfEvent extends Equatable {
  const PdfEvent();

  @override
  List<Object> get props => [];
}

class PdfInit extends PdfEvent {
  final Profile profile;
  final Assessment assessment;

  const PdfInit({required this.profile, required this.assessment});

  @override
  List<Object> get props => [profile, assessment];
}
