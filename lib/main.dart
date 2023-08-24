import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/inference/service_locator.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/repository/_repository.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/validation_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const VisualPT());
}

///Root of Application
///Global routes and themes defined here
class VisualPT extends StatelessWidget {
  const VisualPT({super.key});
  @override
  Widget build(BuildContext context) {
    //TODO: Abstract this into a AppPresenter widget
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => BackendRepository(),
        ),
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                BackendBloc(RepositoryProvider.of<BackendRepository>(context))
                  ..add(const BackendAttemptSync()),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
                RepositoryProvider.of<BackendRepository>(context),
                RepositoryProvider.of<AuthRepository>(context)),
          ),
        ],
        child: CupertinoApp(
          theme: const CupertinoThemeData(
              brightness: Brightness.light,
              textTheme: CupertinoTextThemeData(
                  textStyle: TextStyle(
                      fontFamily: "Unbounded", color: CupertinoColors.black))),
          routes: {
            "/": (context) => const LandingView(),
            "/home": (context) => const HomeView(),
            "/video": (context) => VideoView(onComplete: (_) {}),
            "/validate": (context) => const ValidationView(),
            "/settings": (context) => const SettingsView(),
          },
          onGenerateRoute: (route) {
            if (route.name == "/assessment") {
              final assessmentType = route.arguments as AssessmentType;
              return CupertinoPageRoute(
                  builder: (context) =>
                      PatientView(assessmentType: assessmentType));
            }
            // if (route.name == "/video") {
            //   final args = route.arguments;
            //   return CupertinoPageRoute(
            //       builder: (context) => VideoView(onComplete: args.onComplete));
            // }
            return null;
          },
        ),
      ),
    );
  }
}
