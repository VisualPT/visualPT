import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/service/storage_service.dart';
import 'package:visualpt/utils/validation_utils.dart';

part 'validation_event.dart';
part 'validation_state.dart';

class ValidationBloc extends Bloc<ValidationEvent, ValidationState> {
  ValidationBloc() : super(ValidationLoading()) {
    on<ValidationFetch>(_onFetch);
    on<ValidationInput>(_onInput);
  }

  FutureOr<void> _onFetch(
      ValidationFetch event, Emitter<ValidationState> emit) {
    final data = StorageService().list();
    //TODO: Get the ValidationData from this response
  }

  FutureOr<void> _onInput(
      ValidationInput event, Emitter<ValidationState> emit) {}
}
