import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/styles.dart';
import 'base_view.dart';
import 'components/_components.dart';

//TODO The first view anyone on the app sees. Synonymous with the loading view
class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Stack(
      children: const [
        BaseView(pageTitle: "TODO", child: Text("TODO")),
      ],
    ));
  }
}
