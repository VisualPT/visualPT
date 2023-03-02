part of 'email_bloc.dart';

abstract class EmailState extends Equatable {
  const EmailState();
  
  @override
  List<Object> get props => [];
}

class EmailInitial extends EmailState {}
