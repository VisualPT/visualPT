import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt_collector/features/assessment/service/assessment_utils.dart';
import 'package:visualpt_collector/features/auth/bloc/auth_bloc.dart';
import 'package:visualpt_collector/features/auth/service/auth_repository.dart';
import 'package:visualpt_collector/features/backend/bloc/backend_bloc.dart';
import 'package:visualpt_collector/features/backend/service/backend_repository.dart';
import 'package:visualpt_collector/features/inference/service/service_locator.dart';
import 'package:visualpt_collector/models/ModelProvider.dart';
import 'package:visualpt_collector/core/views/_views.dart';
import 'package:visualpt_collector/features/validation/view/validation_view.dart';

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
            "/settings": (context) => const SettingsView(),
          },
          onGenerateRoute: (route) {
            if (route.name == "/assessment") {
              final type = route.arguments as AssessmentType;
              return CupertinoPageRoute(
                  builder: (context) => AssessmentUtils.getView(type));
            }
            if (route.name == "/validate") {
              final type = route.arguments as AssessmentType;
              return CupertinoPageRoute(
                  builder: (context) => ValidationView(type));
            }
            return null;
          },
        ),
      ),
    );
  }
}
