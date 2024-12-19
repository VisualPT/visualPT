import 'package:visualpt/features/inference/service/ai_model.dart';

class DepthDetectionOutput extends AiModelOutput {
  const DepthDetectionOutput(super.id, super.output);

  @override
  String toString() {
    try {
      return output.toString();
    } catch (e) {
      return "Unable to convert depth output to string";
    }
  }

  @override
  List<Object> get props => [output];
}
