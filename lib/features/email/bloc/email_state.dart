part of 'email_bloc.dart';

sealed class EmailState extends Equatable {
  const EmailState();

  @override
  List<Object> get props => [];
}

class EmailInit extends EmailState {
  const EmailInit();
}

class EmailFetched extends EmailState {
  final String email;
  const EmailFetched(this.email);

  @override
  List<Object> get props => [email];
}

class EmailSending extends EmailState {
  const EmailSending();
}

class EmailSent extends EmailState {
  final Response response;
  const EmailSent(this.response);

  @override
  List<Object> get props => [response];
}

class EmailError extends EmailState {
  final String message;
  const EmailError(this.message);

  @override
  List<Object> get props => [message];
}
