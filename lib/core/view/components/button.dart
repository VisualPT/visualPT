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
          padding: Styles.buttonPadding,
          margin: Styles.buttonMargin,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: Styles.borderRadiusXL,
            // border: Border.all(
            //     color: disabled ? Styles.disabled : Styles.white, width: 1.0),
            color: disabled ? Styles.disabled : Styles.buttonAction,
          ),
          child: Text(text, style: Styles.buttonText),
        ));
  }
}
