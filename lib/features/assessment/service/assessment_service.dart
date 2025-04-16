import 'dart:convert';
import 'dart:typed_data';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/models/ModelProvider.dart';

class AssessmentService {
  Assessment updateAssessmentPdf(Assessment assessment, Uint8List rawPdf) {
    String base64String = base64Encode(rawPdf);
    String header = 'data:application/pdf;base64,';
    final pdf = header + base64String;
    return assessment.copyWith(pdf: pdf);
  }

  static Future<Assessment> assembleAssessment(String id) async {
    //First fetch the assessment object
    final assessmentResult = await ApiService.read(
        Assessment.classType, AssessmentModelIdentifier(id: id));
    if (assessmentResult.data == null) {
      throw Exception(
          "Error while fetching the assessment: ${assessmentResult.errors}");
    }
    // Then fetch the stages,
    final stagesResult = await ApiService.list(Stage.classType,
        where: Stage.ASSESSMENT.eq(assessmentResult.data?.id), getAll: true);
    // Then for each stage, fetch the trials,
    final List<Stage> stages = [];
    for (var stage in stagesResult.data!.items) {
      if (stage == null) {
        continue;
      }
      final trialsResult = await ApiService.list(Trial.classType,
          where: Trial.STAGE.eq(stage.id), getAll: true);
      final List<Trial> trials = [];
      for (var trial in trialsResult.data!.items) {
        if (trial == null) {
          continue;
        }
        trials.add(trial);
      }

      stages.add(stage.copyWith(trials: trials));
    }
    // Then put the assessment object together and return

    final result = assessmentResult.data!.copyWith(stages: stages);
    return result;
  }
}
