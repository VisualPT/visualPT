import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/_views.dart';

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
        "/": (context) => const AuthView(), //TODO make automatic reference based on auth
        "/auth": (context) => const AuthView(),
        "/home": (context) => const HomeView(),
        "/assessment": (context) => const AssessmentView(),
        "/analysis": (context) => const AnalysisView(),
      },
    );
  }
}
 