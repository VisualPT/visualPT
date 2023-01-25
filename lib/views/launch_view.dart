import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/components/view_background.dart';

class LaunchView extends StatelessWidget {
  const LaunchView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Stack(
      children: const [ViewBackground(seed: 0)],
    ));
  }
}
