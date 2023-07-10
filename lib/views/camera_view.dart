import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/app_nav.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    void onComplete(Segment output) {
      log("Put any function in this callback ${output.toString()}");
      AppNav().back(context); //To get out of loading view
      AppNav().back(context); //To get out of camera view
    }

    return VideoView(onComplete: onComplete);
  }
}
