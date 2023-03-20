import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/providers/_providers.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/app_nav.dart';
import 'package:visualpt/views/components/_components.dart';

class AnalysisView extends StatefulWidget {
  final Assessment assessment;

  const AnalysisView({super.key, required this.assessment});

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  late BlocProviders controller;

  @override
  Widget build(BuildContext context) {
    return BaseView(
        pageTitle: "${widget.assessment.type.name} analysis",
        child: AnalysisProvider(
          getProviders: (context) => controller =
              BlocProviders(context: context, pdf: true, email: true),
          onCreate: PdfInit(
              patient: BlocProvider.of<PatientBloc>(context).currentPatient,
              assessment: widget.assessment),
          onReady: pdfReady,
          onLoading: pdfLoading,
          onError: pdfError,
        ));
  }

  Widget pdfReady(BuildContext context, PdfReady state) {
    //TODO safely Remove loading screen
    AppNav().back(context);

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
                onPressed: () => appDialog(
                    context: context,
                    title: "Clear patient data",
                    content: "Do you want to repeat the analysis?",
                    secondaryCallback: () => Navigator.pop(context),
                    primaryCallback: () => {/**TODO */}),
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
                  BlocProvider.of<PatientBloc>(context).currentPatient,
                  widget.assessment,
                  state.pdfView.pdfData!.toString(),
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
                    patient:
                        BlocProvider.of<PatientBloc>(context).currentPatient,
                    assessment:
                        BlocProvider.of<AssessmentBloc>(context).assessment),
              ))
    ]));
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
          BlocProvider.of<EmailBloc>(context).add(EmailSend(
              patient: patient,
              assessment: assessment,
              onSuccess: () => AppNav().reset(context),
              onFail: () {/**TODO  */}));
        });
  }
}
