part of 'email_bloc.dart';

abstract class EmailEvent extends Equatable {
  const EmailEvent();

  @override
  List<Object> get props => [];
}

class EmailSend extends EmailEvent {
  final Patient patient;
  final Assessment assessment;
  final Function() onSuccess;
  final Function() onFail;
  const EmailSend(
      {required this.patient,
      required this.assessment,
      required this.onSuccess,
      required this.onFail});
}
