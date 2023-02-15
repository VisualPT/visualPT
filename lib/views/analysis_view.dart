import 'dart:io';

import 'package:flutter/material.dart';
import 'package:visualpt/views/_views.dart';

class AnalysisView extends StatelessWidget {
  final String assessmentType;
  final List<File> assessmentAssets;
  const AnalysisView(
      {super.key,
      required this.assessmentType,
      required this.assessmentAssets});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      pageTitle: "$assessmentType analysis",
      child: const Placeholder(),
    );
  }
}
