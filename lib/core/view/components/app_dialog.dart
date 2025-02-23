import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/_core.dart';

Future<void> appDialog(
    {required BuildContext context,
    String title = "Proceed",
    String content = "Are you sure?",
    String secondaryAction = "No",
    String primaryAction = "Yes",
    required Function() secondaryCallback,
    required Function() primaryCallback}) {
  return showCupertinoModalPopup(
    useRootNavigator: false,
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Button(
            onPressed: secondaryCallback,
            text: secondaryAction,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Button(
            onPressed: primaryCallback,
            text: primaryAction,
          ),
        ),
      ],
    ),
  );
}
