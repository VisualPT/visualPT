import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/styles.dart';

class ViewBackground extends StatelessWidget {
  const ViewBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double decorSize() => screenSize.height * (Random().nextInt(10) + 50) / 100;
    double decorX() =>
        Random().nextInt(screenSize.width ~/ 3) - (decorSize() / 2);
    double decorY() =>
        Random().nextInt(screenSize.height ~/ 3) - (decorSize() / 2);

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: screenSize.width,
          height: screenSize.height,
          child: Container(
            decoration: const BoxDecoration(color: Styles.backgroundPrimary),
          ),
        ),
        Positioned(
          top: decorY(),
          left: decorX(),
          child: Container(
              height: decorSize(),
              width: decorSize(),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Styles.backgroundAccent)),
        ),
        Positioned(
          bottom: decorY(),
          right: decorX(),
          child: Container(
              height: decorSize(),
              width: decorSize(),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Styles.backgroundAccent)),
        ),
      ],
    );
  }
}
