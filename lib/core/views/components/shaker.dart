//Sourced from https://stackoverflow.com/questions/59123469/how-to-shake-a-widget-in-flutter-on-invalid-input
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class Shaker extends StatefulWidget {
  const Shaker({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<Shaker> createState() => ShakerState();
}

class ShakerState extends State<Shaker> with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), // how long the shake happens
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  math.Vector3 _shake() {
    double progress = animationController.value;
    double offset =
        sin(progress * pi * 5.0); // increase to make it vibrate faster
    return math.Vector3(
        offset * 20, 0.0, 0.0); // increase to make it vibrate wider
  }

  void shake() {
    animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translation(_shake()),
      child: widget.child,
    );
  }
}
