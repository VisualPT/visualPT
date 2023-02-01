import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/components/components.dart';
import 'package:visualpt/views/styles.dart';

class BaseView extends StatelessWidget {
  const BaseView({super.key, required this.child, required this.pageTitle});
  final Widget child;
  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return CupertinoPageScaffold(
      child: Stack(
        children: [
          const ViewBackground(),
          SafeArea(
              //TODO If not signed in, this should be in the middle of the page and bigger
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                child: const Image(
                    image: AssetImage(Styles.mainLogoPath),
                    fit: BoxFit.fitWidth),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 21.0),
                child: Text(
                  pageTitle,
                  style: TextStyle(fontSize: 24),
                  overflow: TextOverflow.visible,
                ),
              )
            ],
          )),
          Positioned(
            left: 16,
            right: 16,
            top: MediaQuery.of(context).size.height / 3,
            child: SizedBox(
                height: screenSize.height,
                width: screenSize.width,
                child: Container(child: child)),
          )
        ],
      ),
    );
  }
}
