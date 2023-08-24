import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/inference/ai_model.dart';
import 'package:visualpt/inference/pose/pose_service.dart';
import 'package:visualpt/repository/video_repository.dart';
import 'package:visualpt/service/inference_service.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'inference_event.dart';
part 'inference_state.dart';

class InferenceBloc extends Bloc<InferenceEvent, InferenceState> {
  InferenceBloc(this.videoRepository) : super(const InferenceLoading()) {
    //TODO dynamically load models through constructor
    _inferenceService = InferenceService();

    on<InferenceInit>(_onInit);
    on<InferenceStart>(_onStart);
    on<InferenceToggle>(_onToggle);
    on<InferenceInput>(_onInput, transformer: concurrent());
    on<InferenceOutput>(_onOutput, transformer: concurrent()); //try droppable
    on<InferenceEnd>(_onEnd);
  }
  final VideoRepository videoRepository;
  static const sampleRateFPS = 15;
  bool isReady = false;
  bool processing = false;
  int frame = 0;
  bool classification = false;
  late InferenceService _inferenceService;
  late int storageBacklog = 0;
  final nullResponsePort = ReceivePort();

//TODO: Figure out what this is doing here
  FutureOr<void> _onInit(
      InferenceInit event, Emitter<InferenceState> emit) async {
    log("Initializing inference bloc");
    await _inferenceService.initialize();
    isReady = true;
    emit(const InferenceStopped());
  }

  FutureOr<void> _onStart(
      InferenceStart event, Emitter<InferenceState> emit) async {
    videoRepository.frameStream.listen((frame) {
      if (isReady) {
        add(InferenceInput(input: frame, ratio: event.ratio));
      }
    });
    emit(const InferenceRunning(null, 1));
  }

  FutureOr<void> _onToggle(
      InferenceToggle event, Emitter<InferenceState> emit) {
    classification = !classification;
  }

  FutureOr<void> _onInput(
      InferenceInput event, Emitter<InferenceState> emit) async {
    frame++;
    if (processing) return null;
    processing = true;
    final data = await _inferenceService
        .inference(cameraImage: event.input, params: {"ratio": event.ratio});
    processing = false;
    if (!isClosed) {
      add(InferenceOutput(
          input: event.input, ratio: event.ratio, output: data));
    }
  }

  FutureOr<void> _onOutput(
      InferenceOutput event, Emitter<InferenceState> emit) {
    if (frame % sampleRateFPS == 0) {
      storageBacklog++;
    }
    if (event.output != null &&
        (event.output as PoseOutput).heightThreshold &&
        storageBacklog > 0) {
      //TODO: Delegate to InferenceRepository to check if all conditions are being met and store data
      storageBacklog--;
      _inferenceService.store(
          event.input, classification, event.ratio, event.output!);
    }
    emit(InferenceRunning(event.output, event.ratio));
  }

  FutureOr<void> _onEnd(InferenceEnd event, Emitter<InferenceState> emit) {
    isReady = false;
    nullResponsePort.close();
    _inferenceService.dispose();
    videoRepository.dispose();
    emit(const InferenceStopped());
  }
}
