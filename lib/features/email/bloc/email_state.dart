part of 'email_bloc.dart';

abstract class EmailState extends Equatable {
  const EmailState();

  @override
  List<Object> get props => [];
}

class EmailNull extends EmailState {
  const EmailNull();
}

class EmailSending extends EmailState {
  const EmailSending();
}

class EmailSent extends EmailState {
  const EmailSent();
}
