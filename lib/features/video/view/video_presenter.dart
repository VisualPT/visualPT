import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/auth/bloc/auth_bloc.dart';
import 'package:visualpt/features/inference/bloc/inference_bloc.dart';
import 'package:visualpt/features/inference/service/pose_detection/pose_detection_output.dart';
import 'package:visualpt/features/timer/bloc/timer_bloc.dart';
import 'package:visualpt/features/video/bloc/video_bloc.dart';
import 'package:visualpt/features/video/service/video_repository.dart';

///Provided by VideoBloc, TimerBloc, & InferenceBloc
class VideoPresenter extends StatelessWidget {
  final String? storePath;
  final Widget Function(BuildContext context, VideoRecording state) onRecording;
  final Widget Function(BuildContext context, VideoStandby state) onStandby;
  final Widget Function(BuildContext context, VideoLoading state) onLoading;
  final Widget Function(BuildContext context, VideoState state, Exception e)
      onError;
  const VideoPresenter(
    this.storePath, {
    super.key,
    required this.onLoading,
    required this.onRecording,
    required this.onStandby,
    required this.onError,
  });

  //TODOV1 final DetectionRepository detectionRepository = DetectionRepository();

  @override
  Widget build(BuildContext context) {
    final VideoRepository videoRepository = VideoRepository(storePath,
        (BlocProvider.of<AuthBloc>(context).state as AuthSuccess).user.email);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              VideoBloc(videoRepository)..add(const VideoInit()),
        ),
        BlocProvider(
          create: (context) => TimerBloc(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) =>
              InferenceBloc<CameraImage, PoseDetectionOutput>(videoRepository)
                ..add(const InferenceInit()),
        ),
        //TODOV1 BlocProvider(
        //   lazy: false,
        //   create: (context) =>
        //       InferenceBloc<PoseDetectionOutput, PoseClassificationOutput>(
        //           detectionRepository)
        //         ..add(const InferenceInit()),
        // )
      ],
      child: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          try {
            if (state is VideoStandby) {
              return onStandby(context, state);
            } else if (state is VideoRecording) {
              return onRecording(context, state);
            } else if (state is VideoLoading) {
              return onLoading(context, state);
            } else {
              throw Exception("Invalid Video State");
            }
          } catch (e) {
            print(e);
            return Container();
            //return onError(context, state, e as Exception);
          }
        },
      ),
    );
  }
}
