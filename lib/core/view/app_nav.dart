import 'package:flutter/cupertino.dart';

class AppNav {
  final BuildContext context;
  AppNav(this.context);

//TODO resolve bug: FlutterError (setState() or markNeedsBuild() called during build. This Overlay widget cannot be marked as needing to build because the framework is already in the process of building widgets. A widget can be marked as needing to be built during the build phase only if one of its ancestors is currently building. This exception is allowed because the framework builds parent widgets before children, which means a dirty descendant will always be built. Otherwise, the framework might not visit this widget during this build phase.
  void back() => WidgetsBinding.instance
      .addPostFrameCallback((_) => Navigator.of(context).pop());

  void pop() => WidgetsBinding.instance
      .addPostFrameCallback((_) => Navigator.of(context).pop());

  void toPath({required String path, Object? args}) {
    Navigator.of(context).pushNamed(path, arguments: args);
  }

  void toView(Widget view) {
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (BuildContext context) => view,
      ),
    );
  }

  void reset() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
