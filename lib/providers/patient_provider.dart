import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/User.dart';

class PatientProvider extends StatefulWidget {
  final void Function(BuildContext) getProviders;
  final Widget Function(BuildContext context, PatientInitial state, User user)
      onInitial;
  final Widget Function(BuildContext context, PatientSet state) onSet;
  final Widget Function(BuildContext context, PatientError state) onError;

  const PatientProvider({
    super.key,
    required this.getProviders,
    required this.onInitial,
    required this.onSet,
    required this.onError,
  });

  @override
  State<PatientProvider> createState() => PatientProviderState();
}

class PatientProviderState extends State<PatientProvider> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PatientBloc()),
        BlocProvider(create: (context) => PatientBloc()),
      ],
      child: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          widget.getProviders(context);
          try {
            if (state is PatientInitial) {
              if (BlocProvider.of<AuthBloc>(context).state is AuthSuccess) {
                return widget.onInitial(
                    context,
                    state,
                    (BlocProvider.of<AuthBloc>(context).state as AuthSuccess)
                        .user);
              } else {
                throw Exception(
                    "User not logged in when trying to render initial patient data");
              }
            } else if (state is PatientSet) {
              return widget.onSet(context, state);
            } else {
              throw Exception("Undefined State");
            }
          } catch (e) {
            return widget.onError(context, PatientError(message: e.toString()));
          }
        },
      ),
    );
  }
}
