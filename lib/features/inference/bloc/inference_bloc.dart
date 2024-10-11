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

//TODO: Add toggleable loggers to all blocs
class InferenceBloc<I extends Identifiable, O extends AiModelOutput>
    extends Bloc<InferenceEvent<I, O>, InferenceState<I, O>> {
  InferenceBloc(this.inferenceRepository, this.outputRepository,
      this.sampleRate, this.storeData)
      : super(InferenceLoading<I, O>()) {
    on<InferenceInit<I, O>>(_onInit);
    on<InferenceStart<I, O>>(_onStart);
    on<InferenceInput<I, O>>(_onInput, transformer: concurrent());
    on<InferenceOutput<I, O>>(_onOutput, transformer: concurrent());
    on<InferenceEnd<I, O>>(_onEnd);

    storageBacklog = 0;
  }

  final Repository<I, O> inferenceRepository;
  final Repository<O, dynamic>? outputRepository;
  final int sampleRate;
  final bool storeData;

  bool isReady = false;
  bool processing = false;
  late int storageBacklog;
  late StreamSubscription<I>? _subscription;
  final nullResponsePort = ReceivePort();

//TODO: Figure out what this is doing here
  FutureOr<void> _onInit(
      InferenceInit event, Emitter<InferenceState> emit) async {
    await inferenceRepository.initialize();
    isReady = true;
    emit(InferenceStandby<I, O>());
  }

  FutureOr<void> _onStart(
      InferenceStart<I, O> event, Emitter<InferenceState> emit) async {
    inferenceRepository.reset(); //Handles the reset case
    _subscription = inferenceRepository.stream.listen((data) {
      if (isReady) {
        add(InferenceInput(data.id, input: data, params: event.params));
      }
    });
    emit(InferenceRunning<I, O>(
        null, "defaultID", const {"height": 0, "width": 0}));
  }

  FutureOr<void> _onInput(
      InferenceInput<I, O> event, Emitter<InferenceState> emit) async {
    if (inferenceRepository.count % sampleRate == 0) {
      storageBacklog++;
    }
    if (processing) return null;
    processing = true;
    final data = await inferenceRepository.runPredict(
        event.id, event.input, event.params);
    processing = false;
    if (isReady && !isClosed && !emit.isDone) {
      add(InferenceOutput(
        event.id,
        input: event.input,
        output: data,
        params: event.params,
      ));
    }
  }

  FutureOr<void> _onOutput(
      InferenceOutput<I, O> event, Emitter<InferenceState> emit) {
    try {
      if (event.output != null) {
        outputRepository?.add(event.output!);
        if (storeData && storageBacklog > 0) {
          //TODO: Delegate to InferenceRepository to check if all conditions are being met and store data
          //TODO: Add a path to the repository to store the data
          storageBacklog--;
          inferenceRepository.store(
              event.id, event.input, event.output!, event.params);
        }
      }
      if (isReady && !isClosed && !emit.isDone) {
        emit(InferenceRunning<I, O>(event.output, event.id, event.params));
      }
    } catch (e) {
      log("Output Error: $e");
    }
  }

  FutureOr<void> _onEnd(InferenceEnd event, Emitter<InferenceState> emit) {
    isReady = false;
    nullResponsePort.close();
    if (_subscription != null) {
      _subscription?.cancel();
    }
    inferenceRepository.dispose();
    emit(InferenceStandby<I, O>());
  }

  // @override
  // void onTransition(
  //     Transition<InferenceEvent<I, O>, InferenceState<I, O>> transition) {
  //   // Always call super.onTransition with the current transition
  //   super.onTransition(transition);
  //   if (transition.currentState is InferenceOutput) {
  //     log('InferenceBloc Change Current State: InferenceOutput, next state: ${transition.event}, next state: ${transition.nextState}');
  //   }
  //   log('InferenceBloc Transition: $transition');
  // }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // Always call super.onError with the current error
    super.onError(error, stackTrace);
    log('InferenceBloc Error: $stackTrace $error');
  }
}
