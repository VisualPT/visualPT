import 'package:flutter/cupertino.dart';
import 'package:visualpt/features/patient_form/view/patient_presenter.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/core/views/_views.dart';
import 'package:visualpt/core/views/app_nav.dart';
import 'package:visualpt/core/views/components/_components.dart';

class PatientView extends StatelessWidget {
  final AssessmentType assessmentType;

  const PatientView({Key? key, required this.assessmentType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nav = AppNav(context);
    try {
      return PatientPresenter(
          onInitial: (context, state, user) => PatientForm(
                //We have checked that the user is logged in, in the provider onInitial
                user: user,
                assessmentType: assessmentType,
              ),
          onSet: (context, state) => AssessmentView(
              assessmentType: assessmentType, patient: state.patient),
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
