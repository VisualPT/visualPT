part of 'email_bloc.dart';

abstract class EmailEvent extends Equatable {
  const EmailEvent();

  @override
  List<Object> get props => [];
}

class EmailSend extends EmailEvent {
  final Subject subject;
  final Assessment assessment;
  final List<String> videos;
  final Function() onSuccess;
  final Function() onFail;
  const EmailSend(
      {required this.subject,
      required this.assessment,
      required this.videos,
      required this.onSuccess,
      required this.onFail});

  @override
  List<Object> get props => [subject, assessment, onSuccess, onFail];
}
