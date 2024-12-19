mixin ModelFile {
  static const String faceDetection = 'models/face_detection.tflite';
  static const String faceMesh = 'models/face_landmark.tflite';
  static const String hands = 'models/hand_landmark.tflite';
  static const String poseDetection = 'models/pose_landmark_heavy.tflite';
  static const String poseClassification = 'models/pose_classification.tflite';
  static const String depthDetection = 'models/depth_detection.tflite';
}

enum InferenceType {
  faceDetection,
  faceMesh,
  hands,
  poseDetection,
  poseClassification,
  depthDetection,
}
