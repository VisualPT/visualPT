import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/email/service/email_service.dart';

part 'email_event.dart';
part 'email_state.dart';

class EmailBloc extends Bloc<EmailEvent, EmailState> {
  EmailBloc() : super(const EmailNull()) {
    on<EmailSend>(
      _onSend,
    );
  }

  ///Sends a curated single template of a basic Assessment with an attached PDF

  FutureOr<void> _onSend(EmailSend event, Emitter<EmailState> emit) async {
    final Map<String, String> templateParams = {
      'patient_name': "${event.patient.first_name} ${event.patient.last_name}",
      'patient_dob': event.patient.dob.toString(),
      'user_email': event.patient.provider_contact,
      'patient_pdf': event.assessment.pdf!,
    };
    Response response = await EmailService().sendAssessmentPDF(templateParams);
    if (response.statusCode == 200) {
      emit(const EmailSent());

      event.onSuccess();
    } else {
      event.onFail();
    }
  }
}

class AssessmentEmailTempates {
  //TODO Set up email templates
  static const ctsib = "";
  static const gait = "";
}
