part of 'pdf_bloc.dart';

abstract class PdfEvent extends Equatable {
  const PdfEvent();

  @override
  List<Object> get props => [];
}

class PdfInit extends PdfEvent {
  final Profile profile;
  final Assessment assessment;
  final Map<String, dynamic> params;
  const PdfInit({
    required this.profile,
    required this.assessment,
    required this.params,
  });

  @override
  List<Object> get props => [profile, assessment];
}
