import 'package:flutter/cupertino.dart';
import 'package:gif_view/gif_view.dart';

import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/assessment/_assessment.dart';

class AssessmentInstructions<T extends BaseAssessment> extends StatefulWidget {
  final AssessmentActive<T> state;
  const AssessmentInstructions(this.state, {super.key});

  @override
  State<AssessmentInstructions<T>> createState() =>
      _AssessmentInstructionsState<T>();
}

class _AssessmentInstructionsState<T extends BaseAssessment>
    extends State<AssessmentInstructions<T>> with TickerProviderStateMixin {
  GifController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = GifController();
  }

  @override
  void dispose() {
    _controller?.stop();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var formattedInstructionList = widget
        .state.config.stageInstructions[widget.state.meta.stage]
        .map((instruction) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(instruction, textAlign: TextAlign.center),
      );
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          Text(widget.state.meta.assessment.name, style: Styles.title),
          Text(
              "Stage ${(widget.state.meta.stage + 1).toString()} of ${widget.state.config.stages.toString()} \n Trial ${widget.state.meta.trial + 1} of ${widget.state.formFields['trial count']?.value ?? widget.state.config.trials}",
              style: Styles.body),
          Text(
            widget.state.config.stageNames[widget.state.meta.stage],
            style: Styles.heading1,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Container(
            height: 2,
            width: MediaQuery.of(context).size.width * 0.8,
            color: Styles.black,
          ),
          const Spacer(),
          const Text("Patient",
              style: Styles.heading2, textAlign: TextAlign.center),
          const Spacer(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: GifView.asset(
              "assets/images/${widget.state.config.type.name}/${widget.state.meta.stage + 1}.gif",
              controller: _controller,
              frameRate: 60,
              progressBuilder: (context) =>
                  const Text('Loading...', textAlign: TextAlign.center),
            ),
          ),
          const Spacer(),
          Container(
            height: 2,
            width: MediaQuery.of(context).size.width * 0.8,
            color: Styles.black,
          ),
          const Spacer(),
          const Text("Therapist Instructions: ",
              style: Styles.heading2, textAlign: TextAlign.center),
          const Spacer(),
          ...formattedInstructionList,
          const Spacer(),
          Row(children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    color: Styles.errorRed, borderRadius: Styles.borderRadiusM),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    //TODO: mark the assessment as aborted
                  },
                  child: const Text("Abort",
                      style: Styles.actionText, textAlign: TextAlign.center),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    color: Styles.actionSecondary,
                    borderRadius: Styles.borderRadiusM),
                child: const Text("Start",
                    style: Styles.actionText, textAlign: TextAlign.center),
              ),
            ),
            const Spacer(),
          ])
        ],
      ),
    );
  }
}
