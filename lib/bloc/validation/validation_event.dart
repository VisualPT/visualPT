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

class ValidationPrev extends ValidationEvent {
  const ValidationPrev({required this.currentKey, required this.keys});
  final String currentKey;
  final List<String> keys;

  @override
  List<Object> get props => [keys];
}

class ValidationNext extends ValidationEvent {
  const ValidationNext({required this.keys});
  final List<String> keys;

  @override
  List<Object> get props => [keys];
}

class ValidationInput extends ValidationEvent {
  final List<int> dataBytes;
  final String key;
  final List<String> keys;
  final bool input;
  const ValidationInput(
      {required this.dataBytes,
      required this.key,
      required this.keys,
      required this.input});

  @override
  List<Object> get props => [dataBytes, input];
}

class ValidationEnd extends ValidationEvent {
  const ValidationEnd();

  @override
  List<Object> get props => [];
}
