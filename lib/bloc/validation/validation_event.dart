part of 'validation_bloc.dart';

abstract class ValidationEvent extends Equatable {
  const ValidationEvent();

  @override
  List<Object> get props => [];
}

class ValidationFetch extends ValidationEvent {
  const ValidationFetch();

  @override
  List<Object> get props => [];
}

class ValidationNext extends ValidationEvent {
  final List<String> keys;
  const ValidationNext({required this.keys});

  @override
  List<Object> get props => [keys];
}

class ValidationInput extends ValidationEvent {
  final String key;
  final List<String> keys;
  final bool input;
  const ValidationInput(
      {required this.key, required this.keys, required this.input});

  @override
  List<Object> get props => [key, input];
}
