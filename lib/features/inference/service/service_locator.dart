import 'package:get_it/get_it.dart';
import 'pose_detection/pose_detection_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // locator.registerSingleton<FaceDetection>(FaceDetection());
  // locator.registerSingleton<FaceMesh>(FaceMesh());
  // locator.registerSingleton<Hands>(Hands());
  locator.registerSingleton<PoseDetection>(PoseDetection());
  // locator.registerSingleton<PoseClassification>(PoseClassification());
}
