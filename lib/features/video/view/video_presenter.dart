import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/assessment/types.dart';
import 'package:visualpt/features/video/service/capture_repository.dart';
import 'package:visualpt/features/video/types.dart';
import 'package:visualpt/features/auth/bloc/auth_bloc.dart';
import 'package:visualpt/features/video/bloc/video_bloc.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/inference/view/pose_detection_indicator.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_repository.dart';

///Provided by VideoBloc, TimerBloc, & InferenceBloc
class VideoPresenter extends StatelessWidget {
  final bool storeData;
  final TrialMeta meta;
  final int address;
  final int durationSeconds;
  final Widget Function(BuildContext context, VideoRecording state) onRecording;
  final Widget Function(BuildContext context, VideoStandby state) onStandby;
  final Widget Function(BuildContext context, VideoPaused state) onPaused;
  final Widget Function(BuildContext context, VideoEnded state) onEnded;
  final Widget Function(BuildContext context, VideoLoading state) onLoading;
  final Widget Function(BuildContext context, VideoState state, Exception e)
      onError;
  const VideoPresenter(
    this.storeData,
    this.meta,
    this.address,
    this.durationSeconds, {
    super.key,
    required this.onRecording,
    required this.onStandby,
    required this.onPaused,
    required this.onEnded,
    required this.onLoading,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => CaptureRepository(meta)),
        RepositoryProvider(
          create: (context) => PoseDetectionRepository(
            meta,
            (BlocProvider.of<AuthBloc>(context).state as AuthSuccess)
                .user
                .email,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => VideoBloc(
                RepositoryProvider.of<CaptureRepository>(context),
                Duration(seconds: durationSeconds),
                storeData)
              ..add(const VideoInit()),
          ),
          BlocProvider(
            lazy: false,
            create: (context) {
              return InferenceBloc<DeviceCapture, PoseDetectionOutput>(
                  RepositoryProvider.of<CaptureRepository>(context),
                  RepositoryProvider.of<PoseDetectionRepository>(context),
                  VPTDetectionRate,
                  storeData)
                ..add(InferenceInit("init", address));
            },
          ),
        ],
        child: BlocBuilder<VideoBloc, VideoState>(
          builder: (context, state) {
            try {
              if (state is VideoStandby) {
                return onStandby(context, state);
              } else if (state is VideoRecording) {
                return onRecording(context, state);
              } else if (state is VideoPaused) {
                return onPaused(context, state);
              } else if (state is VideoEnded) {
                return onEnded(context, state);
              } else if (state is VideoLoading) {
                return onLoading(context, state);
              } else {
                throw Exception("Invalid Video State, $state");
              }
            } catch (e) {
              return onError(context, state, e as Exception);
            }
          },
        ),
      ),
    );
  }
}
