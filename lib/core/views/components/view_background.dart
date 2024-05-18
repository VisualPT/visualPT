import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/views/styles.dart';

class ViewBackground extends StatelessWidget {
  final int seed;
  const ViewBackground({super.key, this.seed = 0});

  @override
  Widget build(BuildContext context) {
    final containerSize = MediaQuery.of(context).size.height / 2;

    return Container(
      color: Styles.backgroundPrimary,
      child: Stack(
        children: [
          Positioned(
            //TODO If able to prevent rebuilds use container1Pos.dx .dy
            left: 90,
            top: 70,
            child: Container(
              width: containerSize,
              height: containerSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Styles.ceruleanBlue,
              ),
            ),
          ),
          Positioned(
            //If able to prevent rebuilds use container2Pos.dx .dy
            left: 30,
            top: 500,
            child: Container(
              width: containerSize,
              height: containerSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Styles.ceruleanBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
