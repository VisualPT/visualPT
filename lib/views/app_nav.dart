import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/_views.dart';

import 'components/app_loading.dart';

//TODO put all navigation here
//TODO safely pop from loading screen, test edge cases
class AppNav {
  AppNav();

  void back(BuildContext context) => Navigator.of(context).pop();

  void loading(BuildContext context) =>
      Navigator.of(context).push(CupertinoPageRoute<void>(
          builder: (BuildContext context) => const AppLoading()));

  void reset(BuildContext context) => Navigator.popUntil(
        context,
        ModalRoute.withName('/'),
      );

  void setAuth(BuildContext context) {
    Future(() async {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            transitionDuration: const Duration(seconds: 0),
            pageBuilder: (_, __, ___) => const AuthView()),
      );
    });
  }

  void setHome(BuildContext context) {
    Future(() async {
      Navigator.of(context).pushReplacementNamed("/home");
    });
  }
}
