import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/components/_components.dart';

class Ctsib {
  List<Widget> get content {
    return [
      IntroView("Eyes Open, Firm Surface"),
      IntroView("Eyes Closed, Firm Surface"),
      IntroView("Eyes Open, Foam Surface"),
      IntroView("Eyes Closed, Foam Surface"),
    ];
  }
}

Widget IntroView(String title) => Column(
      children: [
        Text(title),
        const Text("Ensure device is kept still"),
        const Text("Record all tests from same relative posiotion to patient"),
        const Text("If error is made, press retake")
      ],
    );
