import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/components/_components.dart';
import 'package:visualpt/views/styles.dart';

class BaseView extends StatelessWidget {
  const BaseView({super.key, required this.child, this.pageTitle});
  final Widget child;
  final String? pageTitle;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Styles.backgroundAccent,
          middle: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7),
              child: pageTitle == null
                  ? const Image(
                      image: AssetImage(Styles.mainLogoPath),
                      fit: BoxFit.fitWidth)
                  : Text(
                      pageTitle!,
                      style: Styles.heading3,
                      textAlign: TextAlign.center,
                    )),
          trailing: pageTitle == null
              ? GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/settings"),
                  child: const Icon(
                    CupertinoIcons.settings,
                    color: Styles.black,
                  ))
              : null,
        ),
        child: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: Stack(alignment: Alignment.center, children: [
            const ViewBackground(),
            SingleChildScrollView(
              child: child,
            ),
          ]),
        ));
  }
}
