import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/views/styles.dart';

class ViewBackground extends StatelessWidget {
  const ViewBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Styles.backgroundPrimary,
            Styles.backgroundAccent,
          ],
        ),
      ),
    );
  }
}
