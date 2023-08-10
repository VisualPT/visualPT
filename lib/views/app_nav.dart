import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/_views.dart';

class AppNav {
  AppNav();

//TODO resolve bug: FlutterError (setState() or markNeedsBuild() called during build. This Overlay widget cannot be marked as needing to build because the framework is already in the process of building widgets. A widget can be marked as needing to be built during the build phase only if one of its ancestors is currently building. This exception is allowed because the framework builds parent widgets before children, which means a dirty descendant will always be built. Otherwise, the framework might not visit this widget during this build phase.
  void back(BuildContext context) => WidgetsBinding.instance
      .addPostFrameCallback((_) => Navigator.of(context).pop());

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
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    });
  }

  goToPath(BuildContext context, String path) {
    Future(() async {
      Navigator.of(context).pushNamed(path);
    });
  }

  goToView(BuildContext context, Widget view) {
    Future(() async {
      Navigator.of(context).push(
        CupertinoPageRoute<void>(
          builder: (BuildContext context) => view,
        ),
      );
    });
  }
}
