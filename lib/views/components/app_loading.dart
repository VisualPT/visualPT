import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/_views.dart';

class AppLoading extends StatefulWidget {
  const AppLoading({super.key});

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
    final size = 200.0 - 100.0 * breathe;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: Alignment.center,
            colors: [
              Styles.backgroundPrimary.withOpacity(1.0),
              Styles.backgroundPrimary.withOpacity(0.8),
              Styles.backgroundPrimary.withOpacity(0.6),
              Styles.backgroundPrimary.withOpacity(0.4),
              Styles.backgroundPrimary.withOpacity(0.2),
              Styles.backgroundPrimary.withOpacity(0.0),
            ],
          ),
        ),
        height: size,
        child: const Image(
            image: AssetImage(Styles.mainLogoPath), fit: BoxFit.contain),
      ),
    );
  }
}
