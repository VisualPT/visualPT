part of 'validation_bloc.dart';

abstract class ValidationState extends Equatable {
  const ValidationState();

  @override
  List<Object> get props => [];
}

class ValidationLoading extends ValidationState {}

class ValidationDisplaying extends ValidationState {
  final List<ValidationData> data;
  const ValidationDisplaying({required this.data});

  @override
  List<Object> get props => [data];
}
