import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/core/services/repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:visualpt/features/inference/service/ai_model.dart';

part 'inference_event.dart';
part 'inference_state.dart';

class InferenceBloc<I, O extends AiModelOutput>
    extends Bloc<InferenceEvent<I, O>, InferenceState<I, O>> {
  InferenceBloc(this.inferenceRepository) : super(const InferenceLoading()) {
    on<InferenceInit<I, O>>(_onInit);
    on<InferenceStart<I, O>>(_onStart);
    on<InferenceInput<I, O>>(_onInput, transformer: concurrent());
    on<InferenceOutput<I, O>>(_onOutput, transformer: concurrent());
    on<InferenceEnd<I, O>>(_onEnd);

    storageBacklog = 0;
  }
  final Repository<I, O> inferenceRepository;

  static const sampleRateFrames = 30;
  bool isReady = false;
  bool processing = false;
  late int storageBacklog;
  late StreamSubscription<I>? _subscription;
  final nullResponsePort = ReceivePort();

//TODO: Figure out what this is doing here
  FutureOr<void> _onInit(
      InferenceInit event, Emitter<InferenceState> emit) async {
    log("Initializing inference bloc");
    await inferenceRepository.initialize();
    isReady = true;
    emit(InferenceStandby<I, O>());
  }

  FutureOr<void> _onStart(
      InferenceStart<I, O> event, Emitter<InferenceState> emit) async {
    _subscription = inferenceRepository.stream.listen((data) {
      if (isReady) {
        add(InferenceInput(input: data, params: event.params));
      }
    });
    emit(InferenceRunning<I, O>(null, const {"ratio": 1}));
  }

  FutureOr<void> _onInput(
      InferenceInput<I, O> event, Emitter<InferenceState> emit) async {
    if (inferenceRepository.count++ % sampleRateFrames == 0) {
      storageBacklog++;
    }
    if (processing) return null;
    processing = true;
    final data = await inferenceRepository.predict(event.input, event.params);
    processing = false;
    if (!isClosed && !emit.isDone) {
      add(InferenceOutput(
          input: event.input, params: event.params, output: data));
    }
  }

  FutureOr<void> _onOutput(
      InferenceOutput<I, O> event, Emitter<InferenceState> emit) {
    try {
      if (event.output != null && storageBacklog > 0) {
        //TODO: Delegate to InferenceRepository to check if all conditions are being met and store data
        //TODO: Add a path to the repository to store the data
        storageBacklog--;
        inferenceRepository.store(event.input, event.output!, event.params);
      }
      if (isReady && !isClosed && !emit.isDone) {
        emit(InferenceRunning<I, O>(event.output, event.params));
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  FutureOr<void> _onEnd(InferenceEnd event, Emitter<InferenceState> emit) {
    _subscription?.cancel();
    isReady = false;
    nullResponsePort.close();
    inferenceRepository.dispose();
    emit(InferenceStandby<I, O>());
  }
}
