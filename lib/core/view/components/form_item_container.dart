import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/_core.dart';

class FormItemContainer extends StatelessWidget {
  final Widget child;

  const FormItemContainer({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: Styles.backgroundAccent,
        border: Border.all(color: Styles.backgroundComplementary, width: 1.0),
      ),
      child: child,
    );
  }
}
