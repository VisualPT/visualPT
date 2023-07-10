import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';

class VideoProvider extends StatefulWidget {
  final void Function(BuildContext) getProviders;
  final void Function(Segment) onComplete;
  final Widget Function(BuildContext context, VideoState state) onLoading;
  final Widget Function(BuildContext context, VideoState state) onRecording;
  final Widget Function(BuildContext context, VideoState state) onStandby;
  final Widget Function(BuildContext context, VideoState state, Exception e)
      onError;

  const VideoProvider({
    super.key,
    required this.getProviders,
    required this.onComplete,
    required this.onLoading,
    required this.onRecording,
    required this.onStandby,
    required this.onError,
  });

  @override
  State<VideoProvider> createState() => _VideoProviderState();
}

class _VideoProviderState extends State<VideoProvider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              VideoBloc()..add(VideoInit(onComplete: widget.onComplete)),
        ),
        BlocProvider(
          create: (context) => TimerBloc(),
        ),
        BlocProvider(
          create: (context) => InferenceBloc()..add(const InferenceInit()),
        )
      ],
      child: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          widget.getProviders(context);
          try {
            if (state is VideoStandby) {
              return widget.onStandby(context, state);
            } else if (state is VideoRecording) {
              return widget.onRecording(context, state);
            } else if (state is VideoLoading) {
              return widget.onLoading(context, state);
            } else {
              throw Exception("Invalid Video State");
            }
          } catch (e) {
            return widget.onError(context, state, e as Exception);
          }
        },
      ),
    );
  }
}
