import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/validation/validation_bloc.dart';
import 'package:visualpt/providers/_providers.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/components/_components.dart';

import '../providers/validation_provider.dart';
import 'camera_painters/pose_painter.dart';

//Get all the images and data from the 'raw/' storage folder
// * fetch
//Put the data into an array and display the first value of the array
// * display
//Await for user input (true, false)
// * input
//Pop the value out of the array, and display the next one
//On (true) user input, put the data into the '/processed' folder
// + store
//Restore the state of the user input
// * display

//States:
//Loading
//Displaying

//Events:
//Fetch
//Input

class ValidationView extends StatelessWidget {
  const ValidationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      pageTitle: "Validate",
      child: Stack(
        children: [
          const ViewBackground(),
          ValidationProvider(
            getProviders: (context) =>
                BlocProviders(context: context, validation: true),
            onDisplay: (context, state) => onDisplay(context, state),
            onLoad: (context, state) => onLoad(context, state),
            onError: (context, state) => onError(context, state),
          )
        ],
      ),
    );
  }

  Widget onDisplay(BuildContext context, ValidationDisplay state) {
    final screenSize = MediaQuery.of(context).size;

    return ConstrainedBox(
        constraints: BoxConstraints.tightFor(
            height: state.imageHeight.toDouble(),
            width: state.imageWidth.toDouble()),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Image.network(
              state.imageUrl,
              height: state.imageHeight.toDouble(),
              width: state.imageWidth.toDouble(),
              fit: BoxFit
                  .fitWidth, // This ensures that the image covers the entire space defined by height and width
            ),
            drawPose(state.ratio, state.offsets),
            Positioned(
                bottom: 40,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: 100,
                      maxWidth: MediaQuery.of(context).size.width),
                  child: Column(children: [
                    Text(state.classification == 1 ? "Static" : "Sway",
                        style: Styles.subactionText),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoButton(
                            child: const Text("True"),
                            onPressed: () =>
                                BlocProvider.of<ValidationBloc>(context).add(
                                    ValidationInput(
                                        key: state.key,
                                        keys: state.keys,
                                        input: true))),
                        CupertinoButton(
                            child: const Text("False"),
                            onPressed: () =>
                                BlocProvider.of<ValidationBloc>(context).add(
                                    ValidationInput(
                                        key: state.key,
                                        keys: state.keys,
                                        input: false))),
                      ],
                    )
                  ]),
                ))
          ],
        ));
  }

  onLoad(BuildContext _, ValidationLoad __) {
    return const AppLoading();
  }

  onError(BuildContext _, ValidationError state) {
    return Text(state.message, style: Styles.error);
  }

  Widget drawPose(double ratio, List<Offset>? points) {
    return _ModelPainter(
      customPainter: PosePainter(
        points: points ?? [],
        ratio: ratio,
      ),
    );
  }
}

class _ModelPainter extends StatelessWidget {
  const _ModelPainter({
    required this.customPainter,
    Key? key,
  }) : super(key: key);

  final CustomPainter customPainter;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: customPainter,
    );
  }
}
