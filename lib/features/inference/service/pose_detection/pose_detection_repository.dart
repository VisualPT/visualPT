import 'package:visualpt/core/services/repository.dart';
import 'package:visualpt/core/utils/isolate_utils.dart';
//import 'package:visualpt/features/backend/service/storage_service.dart';
import 'package:visualpt/features/inference/service/model_inference_service.dart';
import 'package:visualpt/features/inference/service/pose_classification/pose_class_output.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';

class DetectionRepository
    extends Repository<PoseDetectionOutput, PoseClassificationOutput> {
  final ModelInferenceService _poseClassService = ModelInferenceService();
  final IsolateUtils _classificationIsolateUtils = IsolateUtils();
  DetectionRepository();

  @override
  Future<void> initialize() async {
    await _classificationIsolateUtils
        .initIsolate("Pose Classification Isolate");
    _poseClassService.setModelConfig(4);
  }

  @override
  Future<PoseClassificationOutput?> runPredict(
      PoseDetectionOutput input, Map<String, dynamic>? params) async {
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
