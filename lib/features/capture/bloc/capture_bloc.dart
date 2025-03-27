import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart' as amplify;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/assessment/types.dart';
import 'package:visualpt/features/capture/service/capture_repository.dart';
import 'package:visualpt/features/capture/service/pose_landmarks.dart';
import 'package:visualpt/models/ModelProvider.dart';

part 'capture_event.dart';
part 'capture_state.dart';

class CaptureBloc extends Bloc<CaptureEvent, CaptureState> {
  CaptureBloc(
    this.repo,
    this.meta,
    this.totalDuration, {
    this.countdown = 3,
    this.ternimateTick = 300, //3 seconds
  })  : _terminateTick = ternimateTick,
        ticker = Ticker(duration: totalDuration),
        super(CaptureDelegated(countdown: countdown)) {
    on<CapturePlay>(_onPlay);
    on<CaptureLandmark>(_onLandmark);
    on<CaptureWarn>(_onWarn);
    on<CapturePause>(_onPause);
    on<CaptureStop>(_onStop);
  }

  final CaptureRepository repo;
  final TrialMeta meta;
  final int countdown;
  final int ternimateTick;
  final Ticker ticker;
  Duration duration = const Duration(seconds: 0);
  final Duration totalDuration;
  late int _countdown;
  late int _terminateTick;
  late amplify.TemporalDateTime start;
  bool forcePause = false;

  StreamSubscription<Duration>? _tickerSubscription;

  FutureOr<void> _onPlay(CapturePlay event, Emitter<CaptureState> emit) async {
    //TODO: Should not be allowed to play if there is no detection
    _terminateTick = ternimateTick;
    start = amplify.TemporalDateTime(DateTime.now());
    _countdown = countdown;
    while (_countdown > 0) {
      emit(CaptureDelegated(
          playing: true,
          message: "Starting in $_countdown",
          countdown: _countdown,
          terminateTick: _terminateTick));
      await Future.delayed(const Duration(seconds: 1));
      _countdown--;
    }
    emit(CaptureDelegated(playing: true, terminateTick: _terminateTick));

    // Use a Completer to keep _onPlay alive
    final completer = Completer<void>();
    _tickerSubscription = ticker.tick().listen((t) {
      duration = t;
      final detection = mostRecentDetection(repo);
      if (detection == null) {
        add(CaptureWarn("No Detection $_terminateTick"));
      }
      if (_terminateTick <= 0) {
        add(CaptureWarn('Invalid Frame Detected'));
      }

      // If the ticker is done, end the capture
      if (t >= totalDuration) {
        add(CapturePause());
        completer.complete(); // Mark the event as completed
      }
    });

    await completer.future; // Keep event handler alive until completed
  }

  FutureOr<void> _onLandmark(
      CaptureLandmark event, Emitter<CaptureState> emit) async {
    if (event.playing) {
      _terminateTick =
          _terminateTick <= ternimateTick ? _terminateTick + 1 : ternimateTick;

      final detection = Detection(
        obtrustion: meta.obtrustion,
        instability: meta.instability,
        direction: CameraDirection.FRONT,
        env: DetectionEnv(
          timestamp: amplify.TemporalDateTime(repo.currentAccel.timestamp),
          accX: repo.currentAccel.x,
          accY: repo.currentAccel.y,
          accZ: repo.currentAccel.z,
        ),
        keypoints: PoseLandmarks(event.landmarks).encode(),
      );
      if (duration < totalDuration && !forcePause) {
        emit(CaptureDelegated(
            playing: event.playing,
            message: _countdown > 0 ? "Starting in $_countdown" : "",
            countdown: _countdown,
            terminateTick: _terminateTick,
            detection: detection));
      }
      if (!(_tickerSubscription?.isPaused ?? true)) {
        repo.add(detection);
      }
    }
  }

//Responsible for decrementing the terminate tick until it is 0 and then ending the capture
  FutureOr<void> _onWarn(CaptureWarn event, Emitter<CaptureState> emit) {
    _terminateTick = _terminateTick - event.decay;

    if (_terminateTick <= 0) {
      add(CapturePause());
    } else {
      emit(CaptureDelegated(
        playing: _terminateTick > 0,
        terminateTick: _terminateTick,
        message: event.warning,
        detection: mostRecentDetection(repo),
      ));
    }
  }

  FutureOr<void> _onPause(CapturePause event, Emitter<CaptureState> emit) {
    forcePause = true;
    _tickerSubscription?.pause();
    emit(const CaptureEnded());
  }

  FutureOr<void> _onStop(CaptureStop event, Emitter<CaptureState> emit) async {
    try {
      if (event.reset) {
        _countdown = countdown;
        duration = const Duration(seconds: 0);
        return emit(
            CaptureDelegated(playing: false, terminateTick: ternimateTick));
      }

      repo.dispose();
    } catch (e) {
      emit(CaptureError(exception: Exception(e)));
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    _tickerSubscription?.cancel();
    // Always call super.onError with the current error
    super.onError(error, stackTrace);
    debugPrint('CaptureBloc Error: $error, $stackTrace');
  }

  /// Returns the latest detection from the repository until 1 second goes by, then returns null
  Detection? mostRecentDetection(CaptureRepository repo) {
    return repo.localStorage.entries.isNotEmpty &&
            repo.localStorage.entries.last.value.env.timestamp
                    .getDateTimeInUtc()
                    .difference(DateTime.now().toUtc())
                    .abs()
                    .inSeconds <=
                1
        ? repo.localStorage.entries.last.value
        : null;
  }
}

class Ticker {
  static const increment = 10;
  final Duration duration;
  const Ticker({required this.duration});
  Stream<Duration> tick() {
    return Stream.periodic(
      const Duration(milliseconds: increment),
      (x) => Duration(milliseconds: increment * x),
    ).takeWhile(
      (d) => d <= duration,
    );
  }
}
