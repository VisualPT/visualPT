import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/_core.dart';

class Button extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final bool disabled;

  const Button(
      {super.key, required this.text, this.onPressed, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: disabled ? null : onPressed,
        child: Container(
          constraints: const BoxConstraints(maxWidth: double.infinity),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: Styles.borderRadiusM,
            border: Border.all(
                color: disabled ? Styles.disabled : Styles.black, width: 1.0),
            color: disabled ? Styles.disabled : Styles.actionPrimary,
          ),
          child: Text(text, style: Styles.actionText),
        ));
  }
}
