import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/views/_views.dart';

class AppLoading extends StatefulWidget {
  final String? message;
  const AppLoading({super.key, this.message});

  @override
  AppLoadingState createState() => AppLoadingState();
}

class AppLoadingState extends State<AppLoading> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Styles.backgroundPrimary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
              image: AssetImage(Styles.mainLogoPath), fit: BoxFit.contain),
          Text(widget.message != null ? widget.message! : "Loading...")
        ],
      ),
    );
  }
}
