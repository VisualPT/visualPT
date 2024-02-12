import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/analysis/bloc/pdf_bloc.dart';
import 'package:visualpt/features/analysis/view/analysis_presenter.dart';
import 'package:visualpt/features/assessment/bloc/assessment_bloc.dart';
import 'package:visualpt/features/email/bloc/email_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/assessment/service/assessment_service.dart';
import 'package:visualpt/core/views/_views.dart';
import 'package:visualpt/core/views/app_nav.dart';
import 'package:visualpt/core/views/components/_components.dart';

class AnalysisView extends StatelessWidget {
  final Assessment assessment;
  final Patient patient;

  const AnalysisView(
      {super.key, required this.assessment, required this.patient});

  @override
  Widget build(BuildContext context) {
    return BaseView(
        pageTitle: "${assessment.type.name} analysis",
        child: AnalysisPresenter(
          onCreate: PdfInit(patient: patient, assessment: assessment),
          onReady: pdfReady,
          onLoading: pdfLoading,
          onError: pdfError,
        ));
  }

  Widget pdfReady(BuildContext context, PdfReady state) {
    return SingleChildScrollView(
      child: Column(children: [
        AspectRatio(
          aspectRatio: 8.5 / 11,
          child: state.pdfView,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          child: Row(
            children: [
              CupertinoButton(
                padding: const EdgeInsets.all(13.0),
                color: CupertinoColors.link,
                onPressed: () {
                  //TODO Add an are you sure popup
                  BlocProvider.of<AssessmentBloc>(context)
                      .add(AssessmentInit(reset: true, patient));
                },
                child: const Text(
                  "Redo Assessment",
                ),
              ),
              const Spacer(),
              CupertinoButton(
                padding: const EdgeInsets.all(13.0),
                color: CupertinoColors.link,
                onPressed: () => onSend(
                  context,
                  patient,
                  assessment,
                  state.pdfView.pdfData!,
                ),
                child: const Text(
                  "Save to email",
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  Widget pdfLoading(BuildContext _, PdfState __) {
    return const AppLoading();
  }

  Widget pdfError(BuildContext context, PdfState _, Exception e) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(e.toString()),
      CupertinoButton(
          child: const Text("Retry"),
          onPressed: () => BlocProvider.of<PdfBloc>(context).add(
                PdfInit(patient: patient, assessment: assessment),
              ))
    ]));
  }

  ///The button that initates the email post
  ///Saves the PDF and stores assessment by default
  void onSend(
    BuildContext context,
    Patient patient,
    Assessment assessment,
    Uint8List pdf,
  ) {
    appDialog(
        context: context,
        title: "Save patient gait data",
        content: "Email will be sent to: ${patient.provider_contact}",
        secondaryCallback: () => Navigator.pop(context),
        primaryCallback: () {
          assessment = AssessmentService().addPDF(assessment, pdf);
          BlocProvider.of<EmailBloc>(context).add(EmailSend(
              patient: patient,
              assessment: assessment,
              onSuccess: () => AppNav(context).setHome(),
              onFail: () => log("Email failed")));
          //TODO: BlocProvider.of<PatientBloc>(context).add(const PatientClear());
        });
  }
}
