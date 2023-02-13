import 'package:flutter/cupertino.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/assessments/_assessments.dart';

void main() {
  runApp(const VisualPT());
}

//TODO VisualPT
//Follow Figma Model
//Connect PDF to email (until EMR integration is available)
//Asseessment tutorial
//Marketing content
//Pitch to physical therapists
//Contact EMR services for connection ($2k investment)

class VisualPT extends StatelessWidget {
  const VisualPT({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(
                  fontFamily: "Unbounded", color: CupertinoColors.black))),
      routes: {
        "/": (context) =>
            const AuthView(), //TODO make automatic reference based on auth
        "/auth": (context) => const AuthView(),
        "/home": (context) => const HomeView(),
        "/analysis": (context) => const AnalysisView(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/assessment") {
          final assessmentType = settings.arguments as AssessmentType;
          return CupertinoPageRoute(
            builder: (_) => AssessmentView(
              assessmentType: assessmentType,
              assessmentViews: AssessmentRouter(assessmentType).assessmentRoute,
            ),
          );
        }
        return null;
      },
    );
  }
}
