import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';

/// Provided PdfBloc & EmailBloc
class AnalysisPresenter extends StatelessWidget {
  final PdfEvent onCreate;
  final Widget Function(BuildContext context, PdfState state) onLoading;
  final Widget Function(BuildContext context, PdfReady state) onReady;
  final Widget Function(BuildContext context, PdfState state, Exception e)
      onError;

  const AnalysisPresenter(
      {super.key,
      required this.onCreate,
      required this.onLoading,
      required this.onReady,
      required this.onError});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PdfBloc()..add(onCreate),
        ),
        BlocProvider(
          create: (context) => EmailBloc(),
        ),
      ],
      child: BlocBuilder<PdfBloc, PdfState>(
        builder: (context, state) {
          try {
            if (state is PdfReady) {
              return onReady(context, state);
            } else if (state is PdfLoading) {
              return onLoading(context, state);
            } else {
              throw Exception("Invalid Pdf State");
            }
          } on Exception catch (e) {
            return onError(context, state, e);
          }
        },
      ),
    );
  }
}
