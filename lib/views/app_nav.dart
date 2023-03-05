import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/_views.dart';

import 'components/app_loading.dart';

//TODO learn how to strucutre Navigator class!
class AppNav {
  AppNav();

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
