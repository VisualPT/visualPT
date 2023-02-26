import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/base_view.dart';
import 'components/_components.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          BaseView(
            pageTitle: "Save 5 clicks & 5 minutes",
            child: BlocProvider(
              create: (context) =>
                  BackendBloc()..add(const BackendAttemptSync()),
              child: BlocBuilder<BackendBloc, BackendState>(
                builder: (context, state) {
                  try {
                    if (state is BackendOnline) {
                      Future(() async {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                              transitionDuration: const Duration(seconds: 0),
                              pageBuilder: (_, __, ___) => const AuthView()),
                        );
                      });
                      return const AppLoading();
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
                  } on Exception catch (e) {
                    BlocProvider.of<BackendBloc>(context)
                        .add(BackendFailSync(e.toString()));
                    return const AppLoading();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
