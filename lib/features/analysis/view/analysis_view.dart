import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/analysis/bloc/pdf_bloc.dart';
import 'package:visualpt/features/analysis/view/analysis_presenter.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/features/email/bloc/email_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';

class AnalysisView<T extends BaseAssessment> extends StatefulWidget {
  final AssessmentAnalysis<T> asmtState;

  const AnalysisView(this.asmtState, {super.key});

  @override
  State<AnalysisView<T>> createState() => _AnalysisViewState<T>();
}

class _AnalysisViewState<T extends BaseAssessment>
    extends State<AnalysisView<T>> {
  double xySensitivity = 1;
  double yzSensitivity = 1;
  double xyOffset = 0;
  double yzOffset = 0;

  getParams() {
    return {
      'sensitivity': (xySensitivity, yzSensitivity),
      'offset': (xyOffset, yzOffset),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        pageTitle: "${widget.asmtState.config.type.name} Report",
        poppable: false,
        child: AnalysisPresenter(
          onCreate: PdfInit(
              profile: widget.asmtState.profile,
              assessment: widget.asmtState.dbAssessment,
              params: getParams()),
          onReady: onReady,
          onLoading: onLoading,
          onError: onError,
        ));
  }

  Widget onReady(BuildContext context, PdfReady state) {
    return SingleChildScrollView(
      child: Column(children: [
        AspectRatio(
          aspectRatio: 8.5 / 11,
          child: PDFView(
            pdfData: state.pdfData,
            enableSwipe: false,
            pageFling: false,
            pageSnap: false,
            onError: (error) => {
              BlocProvider.of<PdfBloc>(context).add(PdfInit(
                  profile: widget.asmtState.profile,
                  assessment: widget.asmtState.dbAssessment,
                  params: getParams()))
            },
            onPageError: (page, error) => {
              BlocProvider.of<PdfBloc>(context).add(PdfInit(
                  profile: widget.asmtState.profile,
                  assessment: widget.asmtState.dbAssessment,
                  params: getParams()))
            },
          ),
        ),
        const Text("Depth Tuning", style: Styles.heading1),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Sensitivity:  ", style: Styles.body),
                  CupertinoSlider(
                    value: yzSensitivity,
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    onChanged: (value) {
                      setState(() => yzSensitivity = value);
                    },
                    onChangeEnd: (value) {
                      BlocProvider.of<PdfBloc>(context).add(PdfInit(
                          profile: widget.asmtState.profile,
                          assessment: widget.asmtState.dbAssessment,
                          params: getParams()));
                    },
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(yzSensitivity.toStringAsPrecision(2),
                        style: Styles.timerTextStyle,
                        textAlign: TextAlign.right),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Offset:  ", style: Styles.body),
                  CupertinoSlider(
                    value: yzOffset,
                    min: -5.0,
                    max: 5.0,
                    divisions: 20,
                    onChanged: (value) {
                      setState(() => yzOffset = value);
                    },
                    onChangeEnd: (value) {
                      BlocProvider.of<PdfBloc>(context).add(PdfInit(
                          profile: widget.asmtState.profile,
                          assessment: widget.asmtState.dbAssessment,
                          params: getParams()));
                    },
                  ),
                  SizedBox(
                    width: 90,
                    child: Text('${yzOffset.toStringAsPrecision(2)}°',
                        style: Styles.timerTextStyle,
                        textAlign: TextAlign.right),
                  ),
                ],
              ),
            ],
          ),
        ),
        // PoseChartAnalysis(
        //     detections: (widget.asmtState.dbAssessment.stages ?? [])
        //         .expand((stage) => stage.trials ?? [])
        //         .cast<Trial>()
        //         .map((trial) =>
        //             PoseLandmarks.decodeCompressed(trial.compressedDetections))
        //         .expand((keypoints) => keypoints)
        //         .toList()),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          child: Column(
            children: [
              Button(
                text: "Refresh PDF",
                onPressed: () => BlocProvider.of<PdfBloc>(context).add(PdfInit(
                    profile: widget.asmtState.profile,
                    assessment: widget.asmtState.dbAssessment,
                    params: getParams())),
              ),
              Button(
                  onPressed: () {
                    //TODO Add an are you sure popup
                    BlocProvider.of<AssessmentBloc>(context)
                        .add(AssessmentInit(widget.asmtState.formFields));
                  },
                  text: "Redo"),
              EmailPresenter(
                  bool.tryParse(
                          widget.asmtState.formFields['store data']?.value) ??
                      true,
                  widget.asmtState.config,
                  widget.asmtState.profile,
                  widget.asmtState.dbAssessment,
                  state.pdfData),
              Button(onPressed: () => AppNav(context).reset(), text: "Exit"),
              // TODO: Blocked by https://github.com/DavBfr/dart_pdf/issues/1638
              // Button(
              //   text: "Print PDF",
              //   onPressed: () async => {
              //     await Printing.layoutPdf(
              //         onLayout: (onLayout) => state.pdfData)
              //   },
              // ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget onLoading(BuildContext _, PdfState __) {
    return const AppLoading(
      message: "Generating PDF report...",
    );
  }

  Widget onError(BuildContext context, PdfState _, Exception e) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          "PDF Generation Error\n ${e.toString()}",
          style: Styles.error,
          textAlign: TextAlign.center,
        ),
      ),
      Button(
          text: "Retry",
          onPressed: () => BlocProvider.of<PdfBloc>(context).add(PdfInit(
              profile: widget.asmtState.profile,
              assessment: widget.asmtState.dbAssessment,
              params: getParams())))
    ]));
  }
}

class EmailPresenter<T extends BaseAssessment> extends StatelessWidget {
  final bool storeData;
  final T meta;
  final Profile profile;
  final Assessment assessment;
  final Uint8List pdf;
  const EmailPresenter(
      this.storeData, this.meta, this.profile, this.assessment, this.pdf,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailBloc, EmailState>(builder: (context, state) {
      return switch (state) {
        EmailInit() =>
          //Email address is not accessible yet
          Container(),
        EmailSending() => const Button(
            disabled: true,
            text: "Sending Email...",
          ),
        EmailFetched() => Button(
            onPressed: () =>
                onSend(context, state.email, profile, assessment, pdf),
            text: "Save",
          ),
        EmailSent() => Button(
            onPressed: () => AppNav(context).reset(),
            text: "Exit",
          ),
        EmailError() => Button(
            onPressed: () =>
                BlocProvider.of<EmailBloc>(context).add(const EmailFetch()),
            text: 'Error ${state.message}',
          )
      };
    });
  }

  ///The button that initates the email post
  ///Saves the PDF and stores assessment by default
  void onSend(
    BuildContext context,
    String email,
    Profile profile,
    Assessment assessment,
    Uint8List pdf,
  ) {
    appDialog(
        context: context,
        title: storeData ? "Save and Send" : "Exit",
        content: storeData
            ? "The data will be used to update the age-group norm table and the PDF will then be emailed to $email."
            : "This data was indicated as a test and will ONLY be sent to your email. Are you sure you want to return home?",
        secondaryCallback: () => Navigator.pop(context),
        primaryCallback: () {
          if (storeData) {
            updateNorms(meta, assessment, profile);
          }
          assessment = AssessmentService().updateAssessmentPdf(assessment, pdf);
          BlocProvider.of<EmailBloc>(context).add(EmailSend(
              storeData: storeData,
              profile: profile,
              assessment: assessment,
              onSuccess: () => AppNav(context).reset(),
              onFail: () => log("Email failed")));
          Navigator.pop(context);
        });
  }
}
