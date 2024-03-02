import 'package:visualpt/features/inference/service/ai_model.dart';

final Map<int, String> classifications = {
  -1: "invalid",
  0: "static",
  1: "arms uncrossed",
  2: "trunk flex",
  3: "feet separated",
};

class PoseClassificationOutput extends AiModelOutput {
  const PoseClassificationOutput(super.output);

  getValue() {
    return double.tryParse(output.toString()) ?? 0;
  }

  @override
  String toString() {
    return "Pose Classification Output: ${getValue()}";
  }

  @override
  List<Object> get props => [""];
}
