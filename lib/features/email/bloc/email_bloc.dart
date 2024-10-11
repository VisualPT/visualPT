import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:visualpt/features/video/service/video_service.dart';

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
    final videos = await VideoService.getVideosInBase64(event.assessment);
    List<Map<String, String>> attachments = [];
    for (int i = 0; i < videos.length; i++) {
      attachments.add({
        'filename':
            '${event.assessment.type.name}_condition${i + 1}_${event.subject.last_name}.mp4',
        'content': videos[i],
        'type': 'video/mp4',
        'disposition': 'attachment'
      });
    }

    final Map<String, String> templateParams = {
      'patient_name': "${event.subject.first_name} ${event.subject.last_name}",
      'patient_dob': event.subject.dob.toString(),
      'user_email': event.subject.provider_contact,
      'patient_pdf': event.assessment.pdf!,
      //TODO: #56 'attachments': attachments
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
