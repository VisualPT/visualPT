import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';

class AnalysisProvider extends StatefulWidget {
  final void Function(BuildContext) getProviders;
  final PdfEvent onCreate;
  final Widget Function(BuildContext context, PdfState state) onLoading;
  final Widget Function(BuildContext context, PdfReady state) onReady;
  final Widget Function(BuildContext context, PdfState state, Exception e)
      onError;

  const AnalysisProvider(
      {super.key,
      required this.onCreate,
      required this.getProviders,
      required this.onLoading,
      required this.onReady,
      required this.onError});

  @override
  State<AnalysisProvider> createState() => _AnalysisProviderState();
}

class _AnalysisProviderState extends State<AnalysisProvider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PdfBloc()..add(widget.onCreate),
        ),
        BlocProvider(
          create: (context) => EmailBloc(),
        ),
      ],
      child: BlocBuilder<PdfBloc, PdfState>(
        builder: (context, state) {
          widget.getProviders(context);
          try {
            if (state is PdfReady) {
              return widget.onReady(context, state);
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
