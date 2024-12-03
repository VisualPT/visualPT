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
        poppable: false,
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
              const Spacer(),
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
              EmailPresenter(asmtState.storeData, asmtState.meta,
                  asmtState.subject, asmtState.dbAssessment, state.pdfData),
              // TODO: Blocked by https://github.com/DavBfr/dart_pdf/issues/1638
              // CupertinoButton(
              //   padding: const EdgeInsets.all(13.0),
              //   color: Styles.actionPrimary,
              //   onPressed: () async => {
              //     BlocProvider.of<PdfBloc>(context).add(PdfPrint(
              //         subject: asmtState.subject,
              //         assessment: asmtState.dbAssessment))
              //   },
              //   child: const Text("Print PDF",
              //       style: TextStyle(color: Styles.black)),
              // ),
              const Spacer(),
              CupertinoButton(
                padding: const EdgeInsets.all(13.0),
                color: Styles.actionPrimary,
                onPressed: () => AppNav(context).setHome(),
                child: const Text("Go home",
                    style: TextStyle(color: Styles.black)),
              ),
              const Spacer(),
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
    return const AppLoading(
      message: "Generating PDF report...",
    );
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
}

class EmailPresenter<T extends BaseAssessment> extends StatelessWidget {
  final bool storeData;
  final T meta;
  final Subject subject;
  final Assessment assessment;
  final Uint8List pdf;
  const EmailPresenter(
      this.storeData, this.meta, this.subject, this.assessment, this.pdf,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailBloc, EmailState>(
      builder: (context, state) {
        if (state is EmailSending) {
          return const CupertinoButton(
            padding: EdgeInsets.all(13.0),
            color: Styles.actionPrimary,
            onPressed: null,
            child:
                Text("Sending Email...", style: TextStyle(color: Styles.black)),
          );
        } else if (state is EmailSent) {
          return const CupertinoButton(
            padding: EdgeInsets.all(13.0),
            color: Styles.actionPrimary,
            onPressed: null,
            child: Text("Email Sent", style: TextStyle(color: Styles.black)),
          );
        } else {
          return CupertinoButton(
            padding: const EdgeInsets.all(13.0),
            color: Styles.actionPrimary,
            onPressed: () => onSend(context, subject, assessment, pdf),
            child:
                const Text("Send Email", style: TextStyle(color: Styles.black)),
          );
        }
      },
    );
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
        title: storeData ? "Save and Send" : "Home",
        content: storeData
            ? "This will assume the data is valid and change the age-group norm table with the data from this assessment. Email will be sent to: ${subject.provider_contact}"
            : "This data was indicated as a test and will ONLY be sent to your email. Are you sure you want to return home?",
        secondaryCallback: () => Navigator.pop(context),
        primaryCallback: () {
          if (storeData) {
            updateNorms(meta, assessment, subject);
          }
          assessment = AssessmentService().addPDF(assessment, pdf);
          BlocProvider.of<EmailBloc>(context).add(EmailSend(
              storeData: storeData,
              subject: subject,
              assessment: assessment,
              onSuccess: () => {
                    //AppNav(context).setHome()
                  },
              onFail: () => log("Email failed")));
          Navigator.pop(context);
          //TODO: BlocProvider.of<PatientBloc>(context).add(const PatientClear());
        });
  }
}
