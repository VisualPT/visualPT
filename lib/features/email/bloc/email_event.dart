part of 'email_bloc.dart';

sealed class EmailEvent extends Equatable {
  const EmailEvent();

  @override
  List<Object> get props => [];
}

class EmailFetch extends EmailEvent {
  const EmailFetch();
}

class EmailSend extends EmailEvent {
  final bool storeData;
  final Profile profile;
  final Assessment assessment;
  final Function() onSuccess;
  final Function() onFail;
  const EmailSend(
      {required this.storeData,
      required this.profile,
      required this.assessment,
      required this.onSuccess,
      required this.onFail});

  @override
  List<Object> get props => [profile, assessment, onSuccess, onFail];
}
