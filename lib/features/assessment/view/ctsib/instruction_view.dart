import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/assessment/bloc/assessment_bloc.dart';
import 'package:visualpt/core/views/_views.dart';
import 'package:visualpt/features/assessment/view/ctsib/ctsib.dart';

class InstructionView extends StatelessWidget {
  final String title;
  final int index;
  const InstructionView(this.title, this.index, {super.key});

  static const instructions = [
    "Patients' landmark boundaries must be as close to the fixed bounding box as possible",
    "Camera position must be static and level",
    "Lighting must be sufficient to clearly see the patient",
  ];

  @override
  Widget build(BuildContext context) {
    var formattedInstructionList = instructions.map((instruction) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(instruction, textAlign: TextAlign.center),
      );
    });

    return BaseView(
      pageTitle: "CTSIB Instructions",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          Text("Criteria ${index.toString()} of ${Ctsib.sequences.toString()}",
              style: Styles.subactionText),
          const Spacer(),
          Container(
            height: 2,
            width: MediaQuery.of(context).size.width * 0.8,
            color: Styles.black,
          ),
          Text(
            title,
            style: Styles.title,
            textAlign: TextAlign.center,
          ),
          Container(
            height: 2,
            width: MediaQuery.of(context).size.width * 0.8,
            color: Styles.black,
          ),
          const Spacer(),
          const Text("Before getting started: ",
              style: Styles.heading3, textAlign: TextAlign.center),
          const Spacer(),
          ...formattedInstructionList,
          const Spacer(),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton(
                  color: Styles.actionPrimary,
                  onPressed: () => BlocProvider.of<AssessmentBloc>(context)
                      .add(AssessmentBegin(context: context, index: index)),
                  child: const Text("Begin", style: Styles.actionText))),
          const Spacer()
        ],
      ),
    );
  }
}
