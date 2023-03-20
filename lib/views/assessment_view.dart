import 'package:flutter/cupertino.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/providers/_providers.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/components/_components.dart';

class AssessmentView extends StatelessWidget {
  final AssessmentType assessmentType;
  const AssessmentView({super.key, required this.assessmentType});

  @override
  //TODO create assessment provider
  Widget build(BuildContext context) {
    return AssessmentProvider(
        assessmentType: assessmentType,
        getProviders: (context) =>
            BlocProviders(context: context, assessment: true, patient: true),
        onForm: (_, __) => PatientForm(assessmentType: assessmentType),
        onIntro: (context, state) => state.getView(context),
        onActive: (context, state) => state.getView(context),
        onSuccess: (context, state) => state.getView(context),
        onError: (_, state) => BaseView(
            pageTitle: "Assessment State Error",
            child: Text(state.e.toString())));
  }
}
