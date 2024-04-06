import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt_collector/features/backend/bloc/backend_bloc.dart';
import 'package:visualpt_collector/core/views/_views.dart';
import 'components/_components.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Stack(
        children: [
          BaseView(
            pageTitle: "Save 5 clicks & 5 minutes",
            child: BlocBuilder<BackendBloc, BackendState>(
              builder: (context, state) {
                try {
                  if (state is BackendOnline) {
                    return AuthView();
                  } else if (state is BackendOffline) {
                    //Return a reason with a retry button
                    return Column(
                      children: [
                        const Text("Backend Offline"),
                        Text(state.message),
                        CupertinoButton(
                            onPressed: () =>
                                BlocProvider.of<BackendBloc>(context)
                                    .add(const BackendAttemptSync()),
                            child: const Text("Retry"))
                      ],
                    );
                  } else {
                    //State is BackendLoading
                    BlocProvider.of<BackendBloc>(context).backendLoading();
                    return const AppLoading();
                  }
                } catch (e) {
                  BlocProvider.of<BackendBloc>(context)
                      .add(BackendFailSync(e.toString()));
                  return const AppLoading();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
