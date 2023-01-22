import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/components/view_background.dart';

class View extends StatelessWidget {
  const View({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        const ViewBackground(),
        SizedBox(
            height: screenSize.height,
            width: screenSize.width,
            child: Container(child: child))
      ],
    );
  }
}
