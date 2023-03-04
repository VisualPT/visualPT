import 'package:flutter/cupertino.dart';

import 'components/app_loading.dart';

class AppNav {
  AppNav();

  void loading(BuildContext context) =>
      Navigator.of(context).push(CupertinoPageRoute<void>(
          builder: (BuildContext context) => const AppLoading()));

  void reset(BuildContext context) => Navigator.popUntil(
        context,
        ModalRoute.withName('/'),
      );
}
