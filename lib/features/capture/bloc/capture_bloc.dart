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

//TODO: Prevent the user from stopping the camera too soon, add a delay
// Ref: https://github.com/flutter/flutter/issues/121659
class CaptureBloc extends Bloc<CaptureEvent, CaptureState> {
  CaptureBloc(this.repo, this.meta, this.totalDuration)
      : _ticker = Ticker(duration: totalDuration),
        super(const CaptureDelegated()) {
    on<CapturePlay>(_onPlay);
    on<CaptureTick>(_onTick);
    on<CaptureLandmark>(_onLandmark);
    on<CaptureStop>(_onStop);
  }

  final CaptureRepository repo;
  final TrialMeta meta;
  late Duration videoDuration = const Duration(seconds: 0);
  final Duration totalDuration;
  final Ticker _ticker;
  late amplify.TemporalDateTime start;
  StreamSubscription<Duration>? _tickerSubscription;

  FutureOr<void> _onPlay(CapturePlay event, Emitter<CaptureState> emit) async {
    start = amplify.TemporalDateTime(DateTime.now());
    _tickerSubscription = _ticker
        .tick()
        .listen((duration) => add(CaptureTick(duration: duration)));
  }

  FutureOr<void> _onTick(CaptureTick event, Emitter<CaptureState> emit) async {
    videoDuration = event.duration;
    final shouldEnd = videoDuration >= totalDuration;
    emit(CaptureDelegated(
        playing: true,
        detection: (repo.localStorage.entries.isNotEmpty &&
                repo.localStorage.entries.last.value.env.timestamp
                        .getDateTimeInUtc()
                        .difference(DateTime.now().toUtc())
                        .abs()
                        .inMilliseconds <=
                    500)
            ? repo.localStorage.entries.last.value
            : null,
        duration: videoDuration,
        shouldEnd: shouldEnd));
  }

  FutureOr<void> _onLandmark(
      CaptureLandmark event, Emitter<CaptureState> emit) async {
    // print(repo.currentAccel);
    final detection = Detection(
      obtrustion: meta.obtrustion,
      instability: meta.instability,
      env: DetectionEnv(
        timestamp: amplify.TemporalDateTime(repo.currentAccel.timestamp),
        accX: repo.currentAccel.x,
        accY: repo.currentAccel.y,
        accZ: repo.currentAccel.z,
      ),
      keypoints: PoseLandmarks(event.landmarks).encode(),
    );

    repo.add(detection);
    //FIXME: Make sure this doesn't interfere with the ticker
    emit(CaptureDelegated(playing: event.playing, detection: detection));
  }

  FutureOr<void> _onStop(CaptureStop event, Emitter<CaptureState> emit) async {
    try {
      _tickerSubscription?.cancel();

      if (event.reset) {
        return emit(const CaptureDelegated(
            playing: false, duration: Duration(seconds: 0), shouldEnd: false));
      }

      emit(const CaptureEnded(Duration.zero));
      repo.dispose();
    } catch (e) {
      emit(CaptureError(exception: Exception(e)));
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // Always call super.onError with the current error
    super.onError(error, stackTrace);
    debugPrint('VideoBloc Error: $error, $stackTrace');
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
