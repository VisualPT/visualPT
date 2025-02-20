import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/view/styles.dart';

class Card extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;
  final bool disabled;

  const Card({
    super.key,
    required this.child,
    this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: onTap != null
            ? Styles.actionSecondary
            : disabled
                ? Styles.disabled
                : Styles.white,
        border: Border.all(
          color: Styles.black,
          width: 1,
        ),
        borderRadius: Styles.borderRadiusM,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: child,
    );
  }
}
