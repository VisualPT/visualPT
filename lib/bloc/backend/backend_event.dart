part of 'backend_bloc.dart';

abstract class BackendEvent extends Equatable {
  const BackendEvent();

  @override
  List<Object> get props => [];
}

class BackendAttemptSync extends BackendEvent {
  const BackendAttemptSync();
}

class BackendFailSync extends BackendEvent {
  final String message;
  const BackendFailSync(this.message);

  @override
  List<Object> get props => [message];
}
