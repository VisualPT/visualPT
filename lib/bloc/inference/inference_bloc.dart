import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/inference/ai_model.dart';
import 'package:visualpt/repository/video_repository.dart';
import 'package:visualpt/service/inference_service.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'inference_event.dart';
part 'inference_state.dart';

class InferenceBloc extends Bloc<InferenceEvent, InferenceState> {
  InferenceBloc(this.videoRepository) : super(const InferenceLoading()) {
    on<InferenceInit>(_onInit);
    on<InferenceStart>(_onStart);
    on<InferenceToggle>(_onToggle);
    on<InferenceInput>(_onInput, transformer: concurrent());
    on<InferenceOutput>(_onOutput, transformer: concurrent());
    on<InferenceEnd>(_onEnd);
    classification = false;
    storageBacklog = 0;

    //TODO dynamically load models through constructor
    _inferenceService = InferenceService();
  }
  final VideoRepository videoRepository;
  static const sampleRateFPS = 15;
  bool isReady = false;
  bool processing = false;
  int frame = 0;
  late bool classification;
  late InferenceService _inferenceService;
  late int storageBacklog;
  late StreamSubscription<CameraImage> _cameraStreamSubscription;
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
    _cameraStreamSubscription = videoRepository.frameStream.listen((image) {
      if (isReady) {
        add(InferenceInput(input: image, ratio: event.ratio));
      }
    });
    emit(const InferenceRunning(null, 1));
  }

  FutureOr<void> _onToggle(
      InferenceToggle event, Emitter<InferenceState> emit) {
    classification = event.classification;
  }

  FutureOr<void> _onInput(
      InferenceInput event, Emitter<InferenceState> emit) async {
    if (frame++ % sampleRateFPS == 0) {
      storageBacklog++;
    }
    if (processing) return null;
    processing = true;
    final data = await _inferenceService
        .inference(cameraImage: event.input, params: {"ratio": event.ratio});
    processing = false;
    if (!isClosed && !emit.isDone) {
      add(InferenceOutput(
          input: event.input, ratio: event.ratio, output: data));
    }
  }

  FutureOr<void> _onOutput(
      InferenceOutput event, Emitter<InferenceState> emit) {
    try {
      if (event.output != null && storageBacklog > 0) {
        //TODO: Delegate to InferenceRepository to check if all conditions are being met and store data
        storageBacklog--;
        _inferenceService.store(
            event.input, classification, event.ratio, event.output!);
      }
      if (!isClosed && !emit.isDone)
        emit(InferenceRunning(event.output, event.ratio));
    } catch (e) {
      log("Error: $e");
    }
  }

  FutureOr<void> _onEnd(InferenceEnd event, Emitter<InferenceState> emit) {
    isReady = false;
    nullResponsePort.close();
    _inferenceService.dispose();
    videoRepository.dispose();
    _cameraStreamSubscription.cancel();
    emit(const InferenceStopped());
  }
}
