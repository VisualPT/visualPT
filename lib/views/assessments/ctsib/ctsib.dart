import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/components/_components.dart';

class Ctsib {
  final sequences = 4;

  List<Widget Function(BuildContext)> introContent() {
    return [
      (context) => introView(context, "Eyes Open,\n Firm Surface", 1),
      (context) => introView(context, "Eyes Closed,\n Firm Surface", 2),
      (context) => introView(context, "Eyes Open,\n Foam Surface", 3),
      (context) => introView(context, "Eyes Closed,\n Foam Surface", 4),
    ];
  }

  List<Widget Function(BuildContext)> captureContent() {
    return [
      (context) => captureView(context, "Eyes Open,\n Firm Surface", 1),
      (context) => captureView(context, "Eyes Closed,\n Firm Surface", 2),
      (context) => captureView(context, "Eyes Open,\n Foam Surface", 3),
      (context) => captureView(context, "Eyes Closed,\n Foam Surface", 4),
    ];
  }
}

Widget introView(BuildContext context, String title, int index) => Builder(
      builder: (context) => Column(
        children: [
          Text(title, style: Styles.title),
          Text(index.toString()),
          const Text("Ensure device is kept still"),
          const Text(
              "Record all tests from same relative posiotion to patient"),
          const Text("If error is made, press retake"),
          Row(
            children: [
              CupertinoButton(
                onPressed: () => BlocProvider.of<AssessmentBloc>(context)
                    .add(AssessmentInit(index)),
                child: const Text("ReInit"),
              ),
              CupertinoButton(
                onPressed: () => BlocProvider.of<AssessmentBloc>(context)
                    .add(AssessmentBegin()),
                child: const Text("Begin"),
              ),
            ],
          )
        ],
      ),
    );

Widget captureView(BuildContext context, String title, int index) => Builder(
      builder: (context) => VideoRecorder(
          title: title,
          onCaptureSaved: (File f) => BlocProvider.of<AssessmentBloc>(context)
              .add(AssessmentIncrement(f))),
    );
