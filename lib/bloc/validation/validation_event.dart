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

class ValidationInput extends ValidationEvent {
  final bool input;
  const ValidationInput({required this.input});

  @override
  List<Object> get props => [input];
}
