import 'package:flutter/cupertino.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/_views.dart';

void main() {
  runApp(const VisualPT());
}

//TODO VisualPT
//Connect to Auth to store user persistantly
//Connect PDF to email (until EMR integration is available)
//Marketing content
//Pitch to physical therapists
//Contact EMR services for connection ($2k investment)

///Root of Application
///Global routes and themes defined here
class VisualPT extends StatelessWidget {
  const VisualPT({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(
          brightness: Brightness.light,
          textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(
                  fontFamily: "Unbounded", color: CupertinoColors.black))),
      routes: {
        "/": (context) => const LandingView(),
        "/home": (context) => const HomeView(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/assessment") {
          final assessmentType = settings.arguments as AssessmentType;
          return CupertinoPageRoute(
              builder: (context) =>
                  AssessmentView(assessmentType: assessmentType));
        }
        // if (settings.name == "/analysis") {
        //   final data = settings.arguments as List;
        //   final type = data[0];
        //   final assets = data[1];
        //   return CupertinoPageRoute(
        //       builder: (context) => AnalysisView(
        //           assessmentType: type, assessmentAssets: assets));
        // }
      },
    );
  }
}
