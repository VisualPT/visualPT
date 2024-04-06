import 'package:flutter/cupertino.dart';
import 'package:visualpt_collector/core/views/_views.dart';

class AppLoading extends StatefulWidget {
  final String? message;
  const AppLoading({super.key, this.message});

  @override
  AppLoadingState createState() => AppLoadingState();
}

class AppLoadingState extends State<AppLoading> with TickerProviderStateMixin {
  late AnimationController breathingController;
  double breathe = 0.0;

  @override
  void initState() {
    super.initState();

    breathingController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        breathingController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        breathingController.forward();
      }
    });

    breathingController.addListener(() {
      setState(() {
        breathe = breathingController.value;
      });
    });
    breathingController.forward();
  }

  @override
  void dispose() {
    breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = 500.0 - 400.0 * breathe;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Styles.backgroundPrimary,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: Alignment.center,
            colors: [
              Styles.backgroundAccent.withOpacity(1.0),
              Styles.backgroundAccent.withOpacity(0.8),
              Styles.backgroundAccent.withOpacity(0.6),
              Styles.backgroundAccent.withOpacity(0.4),
              Styles.backgroundAccent.withOpacity(0.2),
              Styles.backgroundAccent.withOpacity(0.0),
            ],
          ),
        ),
        height: size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
                image: AssetImage(Styles.mainLogoPath), fit: BoxFit.contain),
            Text(widget.message != null ? widget.message! : "Loading...")
          ],
        ),
      ),
    );
  }
}
