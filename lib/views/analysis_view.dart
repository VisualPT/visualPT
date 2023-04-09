import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/providers/_providers.dart';
import 'package:visualpt/service/assessment_service.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/app_nav.dart';
import 'package:visualpt/views/components/_components.dart';

class AnalysisView extends StatefulWidget {
  final Assessment assessment;
  final Patient patient;

  const AnalysisView(
      {super.key, required this.assessment, required this.patient});

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  late BlocProviders controller;

  @override
  void initState() {
    // TODO safely Remove loading screen
    if (!mounted) AppNav().back(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        pageTitle: "${widget.assessment.type.name} analysis",
        child: AnalysisProvider(
          getProviders: (context) => controller =
              BlocProviders(context: context, pdf: true, email: true),
          onCreate:
              PdfInit(patient: widget.patient, assessment: widget.assessment),
          onReady: pdfReady,
          onLoading: pdfLoading,
          onError: pdfError,
        ));
  }

  Widget pdfReady(BuildContext context, PdfReady state) {
    print("PDF READY");
    return SafeArea(
      child: Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 10,
          child: AspectRatio(
            aspectRatio: 8.5 / 11,
            child: state.pdfView,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CupertinoButton(
                padding: const EdgeInsets.all(13.0),
                color: CupertinoColors.link,
                onPressed: () {
                  //TODO Add an are you sure popup
                  BlocProvider.of<AssessmentBloc>(context).add(AssessmentInit(
                      reset: true, context: context, patient: widget.patient));
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
                  widget.patient,
                  widget.assessment,
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
                PdfInit(patient: widget.patient, assessment: widget.assessment),
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
              onSuccess: () => AppNav().setHome(context),
              onFail: () => log("Email failed")));
        });
  }
}
