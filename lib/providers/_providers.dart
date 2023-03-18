//TODO: Future Home for Bloc - View connectors, a new level of abstraction for a stronger, scalable architecture

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';

export 'analysis_provider.dart';
export 'video_provider.dart';

class BlocProviders {
  final BuildContext context;

  AssessmentBloc? assessmentBloc;
  AuthBloc? authBloc;
  BackendBloc? backendBloc;
  VideoBloc? videoBloc;
  EmailBloc? emailBloc;
  PatientBloc? patientBloc;
  PdfBloc? pdfBloc;
  TimerBloc? timerBloc;
  UserBloc? userBloc;

  BlocProviders(
      {required this.context,
      bool assessment = false,
      bool auth = false,
      bool backend = false,
      bool camera = false,
      bool email = false,
      bool patient = false,
      bool pdf = false,
      bool timer = false,
      bool user = false}) {
    assessmentBloc =
        assessment ? BlocProvider.of<AssessmentBloc>(context) : null;
    authBloc = auth ? BlocProvider.of<AuthBloc>(context) : null;
    backendBloc = backend ? BlocProvider.of<BackendBloc>(context) : null;
    videoBloc = camera ? BlocProvider.of<VideoBloc>(context) : null;
    emailBloc = email ? BlocProvider.of<EmailBloc>(context) : null;
    patientBloc = patient ? BlocProvider.of<PatientBloc>(context) : null;
    pdfBloc = pdf ? BlocProvider.of<PdfBloc>(context) : null;
    timerBloc = timer ? BlocProvider.of<TimerBloc>(context) : null;
    userBloc = user ? BlocProvider.of<UserBloc>(context) : null;
  }
}
