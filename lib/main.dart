import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/views.dart';

void main() {
  runApp(const VisualPT());
}

//TODO VisualPT
//Follow Figma Model
//Connect PDF to email (until EMR integration is available)
//Create UI for asseessment tutorial
//Create marketing content
//Market to physical therapists
//Contact EMR services for connection ($2k investment)

class VisualPT extends StatelessWidget {
  const VisualPT({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(routes: {
      "auth": (context) => const AuthView(),
      "home": (context) => const HomeView(),
      "assessment": (context) => const AssessmentView(),
      "analysis": (context) => const AnalysisView(),
    });
  }
}
