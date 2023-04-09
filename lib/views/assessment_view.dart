import 'package:flutter/cupertino.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/providers/_providers.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/app_nav.dart';
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
        onAnalysis: (context, state) => state.getView(context),
        onError: (context, state) => BaseView(
            pageTitle: "Assessment State Error",
            //Create a child view that has the error message and a button to go back
            child: Column(
              children: [
                Text(state.message.toString()),
                CupertinoButton(
                    onPressed: () => AppNav().back(context),
                    child: const Text("Restart Assessment"))
              ],
            )));
  }
}
