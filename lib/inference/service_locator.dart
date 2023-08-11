//TODO determine if this is the best way to do this
import 'package:get_it/get_it.dart';

import 'pose/pose_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // locator.registerSingleton<FaceDetection>(FaceDetection());
  // locator.registerSingleton<FaceMesh>(FaceMesh());
  // locator.registerSingleton<Hands>(Hands());
  locator.registerSingleton<Pose>(Pose());
}
