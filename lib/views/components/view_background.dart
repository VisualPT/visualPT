import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/styles.dart';

class ViewBackground extends StatelessWidget {
  final int seed;
  const ViewBackground({super.key, this.seed = 0});

  Offset _generateRandomPosition(BuildContext context, bool topHalf) {
    final Random random = seed == 0 ? Random() : Random(seed);

    double y = topHalf
        ? random.nextDouble() * (MediaQuery.of(context).size.height / 3)
        : random.nextDouble() * (MediaQuery.of(context).size.height / 3) +
            (MediaQuery.of(context).size.height / 2);
    return Offset(
        random.nextDouble() * (MediaQuery.of(context).size.width / 3), y);
  }

  @override
  Widget build(BuildContext context) {
    final containerSize = MediaQuery.of(context).size.height / 2;
    final container1Pos = _generateRandomPosition(context, true);
    final container2Pos = _generateRandomPosition(context, false);
    return Container(
      color: Styles.backgroundPrimary,
      child: Stack(
        children: [
          Positioned(
            left: container1Pos.dx,
            top: container1Pos.dy,
            child: Container(
              width: containerSize,
              height: containerSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Styles.backgroundAccent,
              ),
            ),
          ),
          Positioned(
            left: container2Pos.dx,
            top: container2Pos.dy,
            child: Container(
              width: containerSize,
              height: containerSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Styles.backgroundAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
