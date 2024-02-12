import 'package:flutter/cupertino.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/patient_form/view/patient_presenter.dart';
import 'package:visualpt/core/views/_views.dart';
import 'package:visualpt/core/views/app_nav.dart';
import 'package:visualpt/core/views/components/_components.dart';

class AssessmentForm<T extends BaseAssessment> extends StatelessWidget {
  final T assessment;
  const AssessmentForm({Key? key, required this.assessment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nav = AppNav(context);
    try {
      return PatientPresenter(
          onInitial: (context, state, user) => PatientForm(
                //We have checked that the user is logged in, in the provider onInitial
                user: user,
                assessmentType: assessment.type,
              ),
          onSet: (context, state) => Container(),
          onError: (context, state) => BaseView(
              pageTitle: "Patient State Error",
              child: Column(
                children: [
                  Text(state.message.toString()),
                  CupertinoButton(
                      onPressed: () => nav.back(),
                      child: const Text("Restart Assessment"))
                ],
              )));
    } catch (e) {
      return BaseView(
          pageTitle: "Patient View Error",
          child: Column(
            children: [
              Text(e.toString()),
              CupertinoButton(
                  onPressed: () => nav.back(),
                  child: const Text("Restart Assessment"))
            ],
          ));
    }
  }
}
