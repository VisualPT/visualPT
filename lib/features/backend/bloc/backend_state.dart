part of 'backend_bloc.dart';

abstract class BackendState extends Equatable {
  const BackendState();

  @override
  List<Object> get props => [];
}

class BackendOnline extends BackendState {
  const BackendOnline();
}

class BackendLoading extends BackendState {
  const BackendLoading();
}

class BackendOffline extends BackendState {
  final String message;
  const BackendOffline(this.message);

  @override
  List<Object> get props => [message];
}
