import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/validation/validation_bloc.dart';
import 'package:visualpt/views/app_nav.dart';

/// Provided by ValidationBloc
class ValidationPresenter extends StatelessWidget {
  final Widget Function(BuildContext context, ValidationDisplay state)
      onDisplay;
  final Widget Function(BuildContext context, ValidationLoad state) onLoad;
  final Widget Function(BuildContext context, ValidationError state) onError;

//TODO: add error handling for...
/* 
* The following HttpException was thrown resolving an image codec:
* Connection closed before full header was received
**/
  const ValidationPresenter({
    super.key,
    required this.onDisplay,
    required this.onLoad,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                ValidationBloc()..add(const ValidationFetch())),
      ],
      child: BlocBuilder<ValidationBloc, ValidationState>(
        builder: (context, state) {
          try {
            if (state is ValidationLoad) {
              return onLoad(context, state);
            } else if (state is ValidationDisplay) {
              return onDisplay(context, state);
            } else if (state is ValidationDispose) {
              AppNav(context).back();
              //TODO: Fix this
              return Container();
            } else {
              throw Exception("Undefined Validation State");
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
