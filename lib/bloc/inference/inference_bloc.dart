import 'dart:async';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/inference/ai_model.dart';
import 'package:visualpt/inference/model_inference_service.dart';
import 'package:visualpt/service/inference_service.dart';
import 'package:visualpt/utils/isolate_utils.dart';

part 'inference_event.dart';
part 'inference_state.dart';

class InferenceBloc extends Bloc<InferenceEvent, InferenceState> {
  final sampleRateFPS = 15;
  late IsolateUtils _poseIsolateUtils;
  late ModelInferenceService _poseInferenceService;
  late InferenceService _inferenceService;
  late int storageBacklog = 0;
  late AiModelOutput? data;

  InferenceBloc() : super(const InferenceDone(false, null)) {
    //TODO dynamically load models through constructor
    _inferenceService = InferenceService();

    on<InferenceInit>(_onInit);
    on<InferenceInput>(_onInput);
    on<InferenceOutput>(_onOutput);
    on<InferenceEnd>(_onEnd);
  }

  FutureOr<void> _onInit(
      InferenceInit event, Emitter<InferenceState> emit) async {
    log("Initializing inference bloc");
    _poseInferenceService = ModelInferenceService();
    _poseInferenceService.setModelConfig(3);
    _poseIsolateUtils = IsolateUtils();
    await _poseIsolateUtils.initIsolate();
    emit(const InferenceDone(true, null));
  }

//TODO temporary fix until I create a InferenceProvider
  FutureOr<void> _onInput(
      InferenceInput event, Emitter<InferenceState> emit) async {
    if (event.frame % sampleRateFPS == 0) {
      storageBacklog++;
    }
    if (state is InferenceLoading) return null;

    emit(const InferenceLoading(true, null));
    data = await _inferenceService.inference(cameraImage: event.input);
    if (!isClosed) add(InferenceOutput(image: event.input, output: data));
    if (data != null && storageBacklog > 0) {
      storageBacklog--;
      _inferenceService.store(
          event.input, event.classification, event.ratio, data!);
    }
  }

  FutureOr<void> _onOutput(
      InferenceOutput event, Emitter<InferenceState> emit) async {
    emit(InferenceDone(true, event.output));
  }

  FutureOr<void> _onEnd(InferenceEnd event, Emitter<InferenceState> emit) {
    _poseIsolateUtils.dispose();
    _poseInferenceService.inferenceResults = null;
  }
}
