import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/assessment/types.dart';
import 'package:visualpt/features/video/types.dart';
import 'package:visualpt/features/auth/bloc/auth_bloc.dart';
import 'package:visualpt/features/timer/bloc/timer_bloc.dart';
import 'package:visualpt/features/video/bloc/video_bloc.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_classification/pose_class_output.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/inference/view/pose_detection_indicator.dart';
import 'package:visualpt/features/video/service/video_detection_repository.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_classification_repository.dart';

///Provided by VideoBloc, TimerBloc, & InferenceBloc
class VideoPresenter extends StatelessWidget {
  final AssessmentMeta meta;
  final int address;
  final Widget Function(BuildContext context, VideoRecording state) onRecording;
  final Widget Function(BuildContext context, VideoStandby state) onStandby;
  final Widget Function(BuildContext context, VideoStopped state) onStopped;
  final Widget Function(BuildContext context, VideoLoading state) onLoading;
  final Widget Function(BuildContext context, VideoState state, Exception e)
      onError;
  const VideoPresenter(
    this.meta,
    this.address, {
    super.key,
    required this.onRecording,
    required this.onStandby,
    required this.onStopped,
    required this.onLoading,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => VideoDetectionRepository(
              meta,
              (BlocProvider.of<AuthBloc>(context).state as AuthSuccess)
                  .user
                  .email),
        ),
        RepositoryProvider(
          create: (context) => DetectionClassificationRepository(meta),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => VideoBloc(
                RepositoryProvider.of<VideoDetectionRepository>(context))
              ..add(const VideoInit()),
          ),
          BlocProvider(
            create: (context) => TimerBloc(),
          ),
          BlocProvider(
            lazy: false,
            create: (context) {
              return InferenceBloc<DeviceCapture, PoseDetectionOutput>(
                  RepositoryProvider.of<VideoDetectionRepository>(context),
                  RepositoryProvider.of<DetectionClassificationRepository>(
                      context),
                  VPTDetectionRate)
                ..add(InferenceInit("init", address));
            },
          ),
          BlocProvider(
            lazy: false,
            create: (context) {
              return InferenceBloc<PoseDetectionOutput,
                      PoseClassificationOutput>(
                  RepositoryProvider.of<DetectionClassificationRepository>(
                      context),
                  null,
                  VPTClassificationRate)
                ..add(InferenceInit("init", address));
            },
          )
        ],
        child: BlocBuilder<VideoBloc, VideoState>(
          builder: (context, state) {
            try {
              if (state is VideoStandby) {
                return onStandby(context, state);
              } else if (state is VideoRecording) {
                return onRecording(context, state);
              } else if (state is VideoStopped) {
                return onStopped(context, state);
              } else if (state is VideoLoading) {
                return onLoading(context, state);
              } else {
                throw Exception("Invalid Video State");
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
