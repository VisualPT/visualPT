import 'package:get_it/get_it.dart';
import 'pose_detection/pose_detection_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<PoseDetection>(PoseDetection());
}
