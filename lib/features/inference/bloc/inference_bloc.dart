import 'dart:async';
import 'dart:developer';
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
  InferenceBloc(this.inputRepository, this.outputRepository, this.sampleRate,
      this.storeData)
      : super(InferenceLoading<I, O>()) {
    on<InferenceInit<I, O>>(_onInit);
    on<InferenceStart<I, O>>(_onStart);
    on<InferenceInput<I, O>>(_onInput, transformer: concurrent());
    on<InferenceOutput<I, O>>(_onOutput, transformer: concurrent());
    on<InferenceEnd<I, O>>(_onEnd);

    storageBacklog = 0;
  }

  final Repository<I, I> inputRepository;
  final Repository<I, O> outputRepository;
  final int sampleRate;
  final bool storeData;

  bool isReady = false;
  bool processing = false;
  late int storageBacklog;
  StreamSubscription<I>? _subscription;

  FutureOr<void> _onInit(
      InferenceInit event, Emitter<InferenceState> emit) async {
    await outputRepository.initialize();
    isReady = true;
    emit(InferenceStandby<I, O>());
  }

  FutureOr<void> _onStart(
      InferenceStart<I, O> event, Emitter<InferenceState> emit) async {
    outputRepository.reset(); //Handles the reset case
    _subscription = inputRepository.stream.listen((data) {
      if (isClosed) {
        _subscription?.cancel();
      }
      if (!isClosed && isReady) {
        add(InferenceInput(data.id, input: data, params: event.params));
      }
    });
    emit(InferenceRunning<I, O>(
        null, "defaultID", const {"height": 0, "width": 0}));
  }

  FutureOr<void> _onInput(
      InferenceInput<I, O> event, Emitter<InferenceState> emit) async {
    if (inputRepository.count % sampleRate == 0) {
      storageBacklog++;
    }
    if (processing) return null;
    processing = true;
    final data =
        await outputRepository.runPredict(event.id, event.input, event.params);
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
      if (event.output != null && !isClosed) {
        outputRepository.add(event.output!);
        if (storeData && storageBacklog > 0) {
          //TODO: Delegate to InferenceRepository to check if all conditions are being met and store data
          //TODO: Add a path to the repository to store the data
          storageBacklog--;
          outputRepository.store(
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
    try {
      isReady = false;
      processing = false;
      _subscription?.cancel();
      //FIXME: When the outputRepository is disposed, the app hangs, so we need to find a way to figure out what is going on and dispose it properly
      //outputRepository.dispose();
      emit(InferenceStandby<I, O>());
    } on Exception catch (e) {
      log("Inference End Error: $e");
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // Always call super.onError with the current error
    super.onError(error, stackTrace);
    log('InferenceBloc Error: $stackTrace $error');
  }
}
