import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
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
        pageTitle: "${asmtState.meta.type.name} Report",
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
          child: PDFView(
              // key: Key(state.pdfData.hashCode.toString()),
              pdfData: state.pdfData,
              enableSwipe: false,
              pageFling: false,
              onError: (error) => {
                    BlocProvider.of<PdfBloc>(context).add(PdfInit(
                        subject: asmtState.subject,
                        assessment: asmtState.dbAssessment))
                  },
              onPageError: (page, error) => {
                    BlocProvider.of<PdfBloc>(context).add(PdfInit(
                        subject: asmtState.subject,
                        assessment: asmtState.dbAssessment))
                  },
              pageSnap: false),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          child: Row(
            children: [
              CupertinoButton(
                padding: const EdgeInsets.all(13.0),
                color: Styles.actionSecondary,
                onPressed: () {
                  //TODO Add an are you sure popup
                  BlocProvider.of<AssessmentBloc>(context).add(
                      AssessmentInit(asmtState.subject, asmtState.storeData));
                },
                child: const Text("Redo Assessment",
                    style: TextStyle(color: Styles.black)),
              ),
              const Spacer(),
              CupertinoButton(
                padding: const EdgeInsets.all(13.0),
                color: Styles.actionPrimary,
                onPressed: () => onSend(
                  context,
                  asmtState.subject,
                  asmtState.dbAssessment,
                  state.pdfData,
                ),
                child: const Text("Save to email",
                    style: TextStyle(color: Styles.black)),
              ),
            ],
          ),
        ),
        // CupertinoButton(
        //     color: Styles.actionSecondary,
        //     child: const Text("Refresh PDF",
        //         style: TextStyle(color: Styles.black)),
        //     onPressed: () => BlocProvider.of<PdfBloc>(context).add(PdfInit(
        //         subject: asmtState.subject,
        //         assessment: asmtState.dbAssessment)))
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
        title: asmtState.storeData ? "Save and Send" : "Home",
        content: asmtState.storeData
            ? "This will assume the data is valid and change the age-group norm table with the data from this assessment. Email will be sent to: ${subject.provider_contact}"
            : "This data was indicated as a test and will not be saved. Are you sure you want to go back?",
        secondaryCallback: () => Navigator.pop(context),
        primaryCallback: () {
          if (asmtState.storeData) {
            updateNorms(asmtState.meta, assessment, subject);
            assessment = AssessmentService().addPDF(assessment, pdf);
            BlocProvider.of<EmailBloc>(context).add(EmailSend(
                subject: subject,
                assessment: assessment,
                onSuccess: () => AppNav(context).setHome(),
                onFail: () => log("Email failed")));
            //TODO: BlocProvider.of<PatientBloc>(context).add(const PatientClear());
          } else {
            AppNav(context).setHome();
          }
        });
  }
}
