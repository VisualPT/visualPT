import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';

class VideoProvider extends StatefulWidget {
  final void Function(BuildContext) getProviders;
  final Widget Function(BuildContext context, CameraState state) onLoading;
  final void Function(VideoOutput) onComplete;
  final Widget Function(BuildContext context, CameraState state) onRecording;
  final Widget Function(BuildContext context, CameraState state) onStandby;
  final Widget Function(BuildContext context, CameraState state, Exception e)
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
              VideoBloc()..add(CameraInit(onComplete: widget.onComplete)),
        ),
        BlocProvider(
          create: (context) => TimerBloc(),
        ),
      ],
      child: BlocBuilder<VideoBloc, CameraState>(
        builder: (context, state) {
          widget.getProviders(context);
          try {
            if (state is CameraStandby) {
              return widget.onStandby(
                context,
                state,
              );
            } else if (state is CameraRecording) {
              return widget.onRecording(context, state);
            } else if (state is CameraLoading) {
              return widget.onLoading(context, state);
            } else {
              throw Exception("Invalid CameraState");
            }
          } on Exception catch (e) {
            return widget.onError(context, state, e);
          }
        },
      ),
    );
  }
}
