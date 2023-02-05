import 'package:flutter/material.dart';
import 'package:visualpt/views/components/components.dart';
import 'package:visualpt/views/views.dart';

class AssessmentView extends StatelessWidget {
  const AssessmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseView(
        pageTitle: "Performing <Assessment>", child: VideoRecorder());
  }
}
