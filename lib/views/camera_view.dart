import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/_views.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    void onComplete() => log("Put any function in this callback");
    return VideoView(sequence: 0, onComplete: onComplete);
  }
}
