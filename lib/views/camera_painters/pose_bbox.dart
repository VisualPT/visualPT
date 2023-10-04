import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/styles.dart';

class PoseBbox extends StatelessWidget {
  const PoseBbox({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final height = constraints.maxHeight * 0.7;
      const aspectRatio = 1 / 3;
      return Center(
          child: SizedBox(
              height: height,
              child: Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Styles.actionPrimary, width: 2.0),
                      color: Styles.transparent,
                    ),
                  ),
                ),
              )));
    });
  }
}
