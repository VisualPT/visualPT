import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart' as a;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:visualpt/features/capture/service/capture_service.dart';

import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/email/service/email_service.dart';

part 'email_event.dart';
part 'email_state.dart';

class EmailBloc extends Bloc<EmailEvent, EmailState> {
  EmailBloc() : super(const EmailInit()) {
    on<EmailFetch>(
      _onFetch,
    );
    on<EmailSend>(
      _onSend,
    );
  }

  FutureOr<void> _onFetch(EmailFetch event, Emitter<EmailState> emit) async {
    final userAttributes = await a.Amplify.Auth.fetchUserAttributes();

    String email = "";
    for (var attribute in userAttributes) {
      if (attribute.userAttributeKey == a.AuthUserAttributeKey.email) {
        email = attribute.value;
      }
    }
    if (email.isEmpty) {
      emit(const EmailError(
          "Email not found. Please check your account settings."));
      return;
    }

    emit(EmailFetched(email));
  }

  ///Sends a curated single template of a basic Assessment with an attached PDF
  FutureOr<void> _onSend(EmailSend event, Emitter<EmailState> emit) async {
    emit(const EmailSending());
    if (event.storeData) {
      final videos = await VideoService.getVideosInBase64(event.assessment);
      List<Map<String, String>> attachments = [];
      for (int i = 0; i < videos.length; i++) {
        attachments.add({
          'filename':
              '${event.assessment.type.name}_condition${i + 1}_${event.profile.lastName}.mp4',
          'content': videos[i],
          'type': 'video/mp4',
          'disposition': 'attachment'
        });
      }
    }
    final userAttributes = await a.Amplify.Auth.fetchUserAttributes();
    String email = "";
    for (var attribute in userAttributes) {
      if (attribute.userAttributeKey == a.AuthUserAttributeKey.email) {
        email = attribute.value;
      }
    }

    if (email.isEmpty) {
      event.onFail();
      return;
    }

    final Map<String, String> templateParams = {
      'patient_name': "${event.profile.firstName} ${event.profile.lastName}",
      'patient_dob': event.profile.dob.toString(),
      'user_email': email,
      'patient_pdf': event.assessment.pdf!,
      //TODO: #56 'attachments': attachments
    };

    Response response = await EmailService().sendAssessmentPDF(templateParams);
    if (response.statusCode == 200) {
      emit(EmailSent(response));
      event.onSuccess();
    } else {
      emit(EmailError("Email failed: ${response.statusCode}"));
      event.onFail();
    }
  }
}

class AssessmentEmailTempates {
  //TODO Set up email templates
  static const ctsib = "";
  static const gait = "";
}
