import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/validation/validation_bloc.dart';
import 'package:visualpt/views/app_nav.dart';

class ValidationProvider extends StatelessWidget {
  final void Function(BuildContext) getProviders;
  final Widget Function(BuildContext context, ValidationDisplay state)
      onDisplay;
  final Widget Function(BuildContext context, ValidationLoad state) onLoad;
  final Widget Function(BuildContext context, ValidationError state) onError;

  const ValidationProvider({
    super.key,
    required this.getProviders,
    required this.onDisplay,
    required this.onLoad,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    void onDispose(BuildContext context) {
      AppNav().back(context);
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                ValidationBloc()..add(const ValidationFetch())),
      ],
      child: BlocBuilder<ValidationBloc, ValidationState>(
        builder: (context, state) {
          getProviders(context);
          try {
            if (state is ValidationLoad) {
              return onLoad(context, state);
            } else if (state is ValidationDisplay) {
              return onDisplay(context, state);
            } else if (state is ValidationDispose) {
              onDispose(context);
              //TODO: Fix this
              return Container();
            } else {
              throw Exception("Undefined State");
            }
          } catch (e) {
            return onError(
                context, ValidationError(state.keys, message: e.toString()));
          }
        },
      ),
    );
  }
}
