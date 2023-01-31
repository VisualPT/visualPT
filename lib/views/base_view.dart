import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/components/patient_form.dart';
import 'package:visualpt/views/components/view_background.dart';
import 'package:visualpt/views/styles.dart';

class BaseView extends StatelessWidget {
  const BaseView({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return CupertinoPageScaffold(
      child: Stack(
        children: [
          const ViewBackground(),
          SafeArea(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                child: const Image(
                    image: AssetImage(Styles.mainLogoPath),
                    fit: BoxFit.fitWidth)),
          ),
          SizedBox(
              height: screenSize.height,
              width: screenSize.width,
              child: Container(child: child)),
          //TODO Fix this
          SafeArea(child: PatientForm())
        ],
      ),
    );
  }
}
