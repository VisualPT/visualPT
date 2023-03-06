import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/components/_components.dart';
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
        //alignment: Alignment.center,
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
                  style: Styles.subtitle,
                  overflow: TextOverflow.visible,
                ),
              )
            ],
          )),
          //TODO make this better and animatable
          Positioned(
            top: screenSize.height / 5,
            width: screenSize.width,
            child: SizedBox(
                //TODO dynamically make the <rest of the screen> instead of this hard coded whack chat
                height: screenSize.height * 20 / 27,
                width: screenSize.width,
                child: Container(child: child)),
          )
        ],
      ),
    );
  }
}
