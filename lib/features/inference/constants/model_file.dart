mixin ModelFile {
  static const String faceDetection = 'assets/models/face_detection.tflite';
  static const String faceMesh = 'assets/models/face_landmark.tflite';
  static const String hands = 'assets/models/hand_landmark.tflite';
  static const String poseDetection =
      'assets/models/pose_landmark_heavy.tflite';
  static const String poseClassification =
      'assets/models/pose_classification.tflite'; //TODO:
}

enum InferenceType {
  faceDetection,
  faceMesh,
  hands,
  poseDetection,
  poseClassification
}
