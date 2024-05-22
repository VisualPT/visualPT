import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/analysis/bloc/pdf_bloc.dart';
import 'package:visualpt/features/analysis/view/analysis_presenter.dart';
import 'package:visualpt/features/assessment/bloc/assessment_bloc.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/email/bloc/email_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/features/assessment/service/assessment_service.dart';
import 'package:visualpt/core/views/_views.dart';
import 'package:visualpt/core/views/components/_components.dart';

class AnalysisView<T extends BaseAssessment> extends StatelessWidget {
  final AssessmentAnalysis<T> asmtState;

  const AnalysisView(this.asmtState, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
        pageTitle: "${asmtState.assessment.type.name} Report",
        child: AnalysisPresenter(
          onCreate: PdfInit(
              subject: asmtState.subject, assessment: asmtState.dbAssessment),
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
                      .add(AssessmentInit(asmtState.subject, reset: true));
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
                  asmtState.subject,
                  asmtState.dbAssessment,
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
                PdfInit(
                    subject: asmtState.subject,
                    assessment: asmtState.dbAssessment),
              ))
    ]));
  }

  ///The button that initates the email post
  ///Saves the PDF and stores assessment by default
  void onSend(
    BuildContext context,
    Subject subject,
    Assessment assessment,
    Uint8List pdf,
  ) {
    appDialog(
        context: context,
        title: "Save and Send",
        content: "Email will be sent to: ${subject.provider_contact}",
        secondaryCallback: () => Navigator.pop(context),
        primaryCallback: () {
          assessment = AssessmentService().addPDF(assessment, pdf);
          BlocProvider.of<EmailBloc>(context).add(EmailSend(
              subject: subject,
              assessment: assessment,
              onSuccess: () => AppNav(context).setHome(),
              onFail: () => log("Email failed")));
          //TODO: BlocProvider.of<PatientBloc>(context).add(const PatientClear());
        });
  }
}
