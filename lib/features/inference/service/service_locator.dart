import 'package:get_it/get_it.dart';
import 'package:visualpt/features/inference/service/depth_detection/depth_detection_service.dart';
import 'pose_detection/pose_detection_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // locator.registerSingleton<FaceDetection>(FaceDetection());
  // locator.registerSingleton<FaceMesh>(FaceMesh());
  // locator.registerSingleton<Hands>(Hands());
  locator.registerSingleton<PoseDetection>(PoseDetection());
  locator.registerSingleton<DepthDetection>(DepthDetection());
  // locator.registerSingleton<PoseClassification>(PoseClassification());
}
