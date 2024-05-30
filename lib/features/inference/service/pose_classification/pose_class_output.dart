import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/views/_views.dart';
import 'package:visualpt/features/inference/service/ai_model.dart';

final Map<int, String> classifications = {
  0: "static",
  1: "arms uncrossed",
  2: "trunk flex",
  3: "feet separated",
  -1: "invalid",
};

class PoseClassificationOutput extends AiModelOutput {
  const PoseClassificationOutput(super.id, super.output);

  //Get the index of the highest valued number in the classification output map
  int getIndex() {
    try {
      final value = (output as List<double>).reduce((acc, classification) =>
          acc = classification > acc ? classification : acc);
      final index = output.indexOf(value);
      return index;
    } catch (e) {
      print(e);
      return -1;
    }
  }

  String get name {
    try {
      return classifications[getIndex()]!;
    } catch (e) {
      return "invalid";
    }
  }

  Color getColor() {
    switch (name) {
      case "static":
        return Styles.green;
      case "arms uncrossed":
        return Styles.yellow;
      case "trunk flex":
        return Styles.yellow;
      case "feet separated":
        return Styles.yellow;
      default:
        return Styles.blue;
    }
  }

  @override
  String toString() {
    try {
      return "${getIndex().toString()}: $name";
    } catch (e) {
      return "-1: invalid prediction";
    }
  }

  @override
  List<Object> get props => [output];
}
