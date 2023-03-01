import 'package:flutter/cupertino.dart';

Future<void> consentDialog(
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
          child: CupertinoButton(
            color: CupertinoColors.secondaryLabel,
            onPressed: secondaryCallback,
            child: Text(secondaryAction),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CupertinoButton(
            color: CupertinoColors.link,
            onPressed: primaryCallback,
            child: Text(primaryAction),
          ),
        ),
      ],
    ),
  );
}
