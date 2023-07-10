//TODO address memory leak with this bloc

import 'dart:async';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/inference/model_inference_service.dart';
import 'package:visualpt/service/inference_service.dart';
import 'package:visualpt/utils/isolate_utils.dart';

part 'inference_event.dart';
part 'inference_state.dart';

class InferenceBloc extends Bloc<InferenceEvent, InferenceState> {
  late IsolateUtils _poseIsolateUtils;
  late ModelInferenceService _poseInferenceService;
  late InferenceService _inferenceService;

  late Map<String, dynamic>? aggregatedResponse;

  bool processing = false;

  InferenceBloc() : super(InferenceLoading()) {
    //TODO dynamically load models through constructor
    _inferenceService = InferenceService();

    on<InferenceInit>(_onInit);
    on<InferenceInput>(_onInput);
    on<InferenceEnd>(_onEnd);
  }

  FutureOr<void> _onInit(
      InferenceInit event, Emitter<InferenceState> emit) async {
    log("Configuring Models and Isolates");
    _poseInferenceService = ModelInferenceService();
    _poseInferenceService.setModelConfig(3);
    aggregatedResponse = {};
    _poseIsolateUtils = IsolateUtils();
    await _poseIsolateUtils.initIsolate();
  }

  FutureOr<void> _onInput(
      InferenceInput event, Emitter<InferenceState> emit) async {
    if (processing) {
      return;
    }
    processing = true;
    final data = await _inferenceService.inference(cameraImage: event.input);
    aggregatedResponse =
        data; //TODO temporary fix until I create a InferenceProvider
    data != null ? emit(InferenceDone(response: data)) : null;

    processing = false;
  }

  FutureOr<void> _onEnd(InferenceEnd event, Emitter<InferenceState> emit) {
    _poseIsolateUtils.dispose();
    _poseInferenceService.inferenceResults = null;
  }

  Future<void> inference({required CameraImage cameraImage}) async {
    processing == true;
    if (_poseInferenceService.model.interpreter != null) {
      await _poseInferenceService.inference(
        isolateUtils: _poseIsolateUtils,
        cameraImage: cameraImage,
      );

      aggregatedResponse!
          .addAll(_poseInferenceService.inferenceResults ?? {"pose": null});
      processing = false;
    }
  }
}
