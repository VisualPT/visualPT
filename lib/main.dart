import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/inference/service_locator.dart';
import 'package:visualpt/models/ModelProvider.dart';
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
    return BlocProvider(
      create: (context) => UserBloc(),
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
          "/validate": (context) => const ValidationView(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == "/assessment") {
            final assessmentType = settings.arguments as AssessmentType;
            return CupertinoPageRoute(
                builder: (context) =>
                    PatientView(assessmentType: assessmentType));
          }
          return null;
        },
      ),
    );
  }
}
