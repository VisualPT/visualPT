import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/user/user_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/providers/_providers.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/app_nav.dart';
import 'package:visualpt/views/components/_components.dart';

class PatientView extends StatelessWidget {
  final AssessmentType assessmentType;

  const PatientView({Key? key, required this.assessmentType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      return PatientProvider(
          getProviders: (context) =>
              BlocProviders(context: context, patient: true, user: true),
          onInitial: (context, state) => PatientForm(
                //We have checked that the user is logged in, in the provider onInitial
                user: BlocProvider.of<UserBloc>(context).state.user!,
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
                      onPressed: () => AppNav().back(context),
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
                  onPressed: () => AppNav().back(context),
                  child: const Text("Restart Assessment"))
            ],
          ));
    }
  }
}
