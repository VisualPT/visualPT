import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/core/views/_views.dart';
import 'package:visualpt/core/views/app_nav.dart';
import 'package:visualpt/features/assessment/view/patient_form.dart';
import 'package:visualpt/features/auth/bloc/auth_bloc.dart';

class AssessmentForm<T extends BaseAssessment> extends StatelessWidget {
  final T assessment;
  const AssessmentForm({Key? key, required this.assessment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nav = AppNav(context);
    try {
      return PatientForm(
        user: (BlocProvider.of<AuthBloc>(context).state as AuthSuccess).user,
        assessmentType: assessment.type,
      );
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
