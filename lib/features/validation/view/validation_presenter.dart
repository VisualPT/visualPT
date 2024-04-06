import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt_collector/features/validation/bloc/validation_bloc.dart';
import 'package:visualpt_collector/models/ModelProvider.dart';

/// Provided by ValidationBloc
class ValidationPresenter extends StatelessWidget {
  final AssessmentType type;
  final Widget Function(BuildContext context, ValidationDisplay state)
      onDisplay;
  final Widget Function(BuildContext context, ValidationLoad state) onLoad;
  final Widget Function(BuildContext context, ValidationDispose state)
      onDispose;
  final Widget Function(BuildContext context, ValidationError state) onError;
  const ValidationPresenter(
    this.type, {
    required this.onDisplay,
    required this.onLoad,
    required this.onDispose,
    required this.onError,
    super.key,
  });

//TODO: add error handling for...
/* 
* "
* The following HttpException was thrown resolving an image codec:
* Connection closed before full header was received
* "
**/

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                ValidationBloc(type.name)..add(const ValidationFetch())),
      ],
      child: BlocBuilder<ValidationBloc, ValidationState>(
        builder: (context, state) {
          try {
            if (state is ValidationLoad) {
              return onLoad(context, state);
            } else if (state is ValidationDisplay) {
              return onDisplay(context, state);
            } else if (state is ValidationDispose) {
              return onDispose(context, state);
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
