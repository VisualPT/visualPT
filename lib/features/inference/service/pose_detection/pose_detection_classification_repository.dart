import 'package:visualpt_collector/core/services/repository.dart';
import 'package:visualpt_collector/core/utils/isolate_utils.dart';
//import 'package:visualpt_collector/features/backend/service/storage_service.dart';
import 'package:visualpt_collector/features/inference/service/model_inference_service.dart';
import 'package:visualpt_collector/features/inference/service/pose_classification/pose_class_output.dart';
import 'package:visualpt_collector/features/inference/service/pose_detection/pose_detection_output.dart';

class DetectionClassificationRepository
    extends Repository<PoseDetectionOutput, PoseClassificationOutput> {
  final ModelInferenceService _poseClassService = ModelInferenceService();
  final IsolateUtils _classificationIsolateUtils = IsolateUtils();
  DetectionClassificationRepository();

  @override
  Future<void> initialize(int address) async {
    await _classificationIsolateUtils
        .initIsolate("Pose Classification Isolate");
    _poseClassService.setModelConfig(4);
    isInitialized = true;
  }

  @override
  Future<PoseClassificationOutput?> runPredict(
      PoseDetectionOutput input, Map<String, dynamic>? params) async {
    if (!isInitialized) {
      throw Exception("Classification Inference Service not initialized");
    }
    await _poseClassService.inference(
      isolateUtils: _classificationIsolateUtils,
      input: input,
      params: params,
    );
    return _poseClassService.inferenceResults as PoseClassificationOutput?;
  }

  @override
  Future<void> store(PoseDetectionOutput input, PoseClassificationOutput output,
      Map<String, dynamic>? params) async {
    if (!isInitialized) {
      throw Exception("Classification Inference Service not initialized");
    }
    //StorageService storageService = StorageService();
    //final output = "TODO"; //TODO: parse the output here
    // The image and output of pose detection are stored in the Video Repository
    // final dataPayload = S3DataPayload.string(output);

    // final key = "${DateTime.now().millisecondsSinceEpoch}";
    // storageService.upload(
    //     dataPayload, 'raw/$key.csv', StorageAccessLevel.private);
  }

  @override
  void dispose() {
    _poseClassService.inferenceResults = null;
    _classificationIsolateUtils.dispose();
  }
}
