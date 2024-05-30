import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/views/styles.dart';

class ViewBackground extends StatelessWidget {
  const ViewBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final containerSize = MediaQuery.of(context).size.height / 3;

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
      child: Stack(
        children: [
          Positioned(
            left: MediaQuery.of(context).size.width * 0.2,
            top: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Styles.ceruleanBlue,
                boxShadow: [
                  BoxShadow(
                    color: Styles.black.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, 5), // changes position of shadow
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.6,
            top: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              width: containerSize * 0.8,
              height: containerSize * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Styles.ceruleanBlue,
                boxShadow: [
                  BoxShadow(
                    color: Styles.black.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, 5), // changes position of shadow
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
