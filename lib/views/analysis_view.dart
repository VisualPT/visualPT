import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/assessment_service.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/app_nav.dart';
import 'package:visualpt/views/components/_components.dart';

class AnalysisView extends StatelessWidget {
  final Patient patient;
  final Assessment assessment;
  final List<File> assessmentAssets;

  const AnalysisView(
      {super.key,
      required this.patient,
      required this.assessment,
      required this.assessmentAssets});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PdfBloc(),
        ),
      ],
      child: BaseView(
        pageTitle: "${assessment.type.name} analysis",
        child: BlocBuilder<PdfBloc, PdfState>(builder: (context, state) {
          if (state is PdfLoaded) {
            return SafeArea(
                child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                  height: screenSize.height - 30, width: screenSize.width - 20),
              Positioned(
                top: 20,
                child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Text("Generated PDF",
                        style: Styles.titleTextStyle)),
              ),
              SizedBox(
                width: screenSize.width - 20,
                child: AspectRatio(
                  aspectRatio: 8.5 / 11,
                  child: state.pdfView,
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  child: SizedBox(
                      width: screenSize.width - 20,
                      child: Row(children: [
                        CupertinoButton(
                          padding: const EdgeInsets.all(13.0),
                          color: Styles.brandTertiaryOrange.withOpacity(0.8),
                          onPressed: () {
                            appDialog(
                                context: context,
                                title: "Clear patient data",
                                content: "Do you want to repeat the analysis?",
                                secondaryCallback: () => Navigator.pop(context),
                                primaryCallback: () => {/**TODO */});
                          },
                          child: const Icon(CupertinoIcons.restart, size: 35),
                        ),
                        const Spacer(),
                        SizedBox(
                          child: CupertinoButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 13,
                                horizontal: (screenSize.width / 4) - 50),
                            color: CupertinoColors.link,
                            onPressed: () => onSend(
                              context,
                              patient,
                              assessment,
                              state.pdfView.pdfData!.toString(),
                            ),
                            child: const Text("Save to email",
                                style: Styles.buttonLabelStyle),
                          ),
                        )
                      ])))
            ]));
          } else if (state is PdfLoading) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state is PdfError) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text(state.exception.toString()),
                  CupertinoButton(
                      child: const Text("Retry"),
                      onPressed: () => BlocProvider.of<PdfBloc>(context).add(
                            PdfInit(
                                patient: BlocProvider.of<PatientBloc>(context)
                                    .currentPatient,
                                assessment:
                                    BlocProvider.of<AssessmentBloc>(context)
                                        .assessment,
                                assets: assessmentAssets),
                          ))
                ]));
          } else {
            return const Center(
              child: Text("Invalid PDF State"),
            );
          }
        }),
      ),
    );
  }

  ///The button that initates the email post
  ///Saves the PDF and stores assessment by default
  void onSend(
    BuildContext context,
    Patient patient,
    Assessment assessment,
    String pdf,
  ) {
    appDialog(
        context: context,
        title: "Save patient gait data",
        content: "Email will be sent to: ${patient.provider_contact}",
        secondaryCallback: () => Navigator.pop(context),
        primaryCallback: () {
          AppNav().loading(context);

          AssessmentService()
              .createAssessment(assessment.type, DateTime.now(), patient.id);
          BlocProvider.of<EmailBloc>(context).add(EmailSend(
              patient: patient,
              assessment: assessment,
              onSuccess: () => AppNav().reset(context),
              onFail: () {/**TODO  */}));
        });
  }
}
