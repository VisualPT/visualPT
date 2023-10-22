import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/auth/bloc/auth_bloc.dart';
import 'package:visualpt/features/patient_form/bloc/patient_bloc.dart';
import 'package:visualpt/models/User.dart';

///Provided AuthBloc & PatientBloc
class PatientPresenter extends StatelessWidget {
  final Widget Function(BuildContext context, PatientInitial state, User user)
      onInitial;
  final Widget Function(BuildContext context, PatientSet state) onSet;
  final Widget Function(BuildContext context, PatientError state) onError;

  const PatientPresenter({
    super.key,
    required this.onInitial,
    required this.onSet,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PatientBloc()),
      ],
      child: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          try {
            if (state is PatientInitial) {
              //TODO: Split this up, we dont want the blocs to be tied together like this. Connect via the repository layer.
              if (BlocProvider.of<AuthBloc>(context).state is AuthSuccess) {
                return onInitial(
                    context,
                    state,
                    (BlocProvider.of<AuthBloc>(context).state as AuthSuccess)
                        .user);
              } else {
                throw Exception(
                    "User not logged in when trying to render initial patient data");
              }
            } else if (state is PatientSet) {
              return onSet(context, state);
            } else {
              throw Exception("Undefined Patient State");
            }
          } catch (e) {
            return onError(context, PatientError(message: e.toString()));
          }
        },
      ),
    );
  }
}
