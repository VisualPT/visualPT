import 'package:visualpt/core/services/repository.dart';
import 'package:visualpt/core/utils/isolate_utils.dart';
import 'package:visualpt/features/assessment/types.dart';
import 'package:visualpt/features/inference/constants/model_file.dart';
import 'package:visualpt/features/inference/service/model_inference_service.dart';
import 'package:visualpt/features/inference/service/pose_classification/pose_class_output.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';

class PoseClassificationRepository
    extends Repository<PoseDetectionOutput, PoseClassificationOutput> {
  final ModelInferenceService _poseClassService =
      ModelInferenceService(InferenceType.poseClassification);
  final IsolateUtils _classificationIsolateUtils =
      IsolateUtils("Pose Classification Isolate");
  final TrialMeta assessmentMeta;
  PoseClassificationRepository(this.assessmentMeta) : super(assessmentMeta);

  @override
  Future<void> initialize() async {
    isInitialized = true;
  }

  @override
  Future<PoseClassificationOutput?> runPredict(String id,
      PoseDetectionOutput input, Map<String, dynamic>? params) async {
    if (!isInitialized) {
      throw Exception("Classification Inference Service not initialized");
    }
    final output = await _poseClassService.inference(
      id: id,
      isolateUtils: _classificationIsolateUtils,
      input: input,
      params: params,
    ) as PoseClassificationOutput?;
    if (output != null) localStorage[input] = output;
    return output;
  }

  @override
  Future<void> store(String id, PoseDetectionOutput input,
      PoseClassificationOutput output, Map<String, dynamic>? params) async {
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
    _classificationIsolateUtils.dispose();
    _poseClassService.dispose();
  }
}
