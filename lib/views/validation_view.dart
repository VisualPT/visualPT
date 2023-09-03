import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/validation/validation_bloc.dart';
import 'package:visualpt/presenter/_presenter.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/app_nav.dart';
import 'package:visualpt/views/components/_components.dart';

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
          ValidationPresenter(
            //onCollect: (context, state) => VideoView(true, (_) => {}),
            onDisplay: (context, state) => onDisplay(context, state),
            onLoad: (context, state) => const AppLoading(),
            onDispose: (context, state) => onDispose(context, state),
            //TODO: Create AppError widget for all blocks
            onError: (context, state) => onError(context, state),
          )
        ],
      ),
    );
  }

  Widget onDisplay(BuildContext context, ValidationDisplay state) {
    return Column(
      children: [
        ConstrainedBox(
            constraints: BoxConstraints.tightFor(
                height: state.imageHeight.toDouble() * state.ratio,
                width: state.imageWidth.toDouble() * state.ratio),
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
                drawPose(state.offsets.map((o) => o * state.ratio).toList()),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                      color: CupertinoColors.black.withOpacity(0.5),
                      child: Text(state.classification == 1 ? "Static" : "Sway",
                          style: Styles.actionText)),
                ),
              ],
            )),
        ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: 100, maxWidth: MediaQuery.of(context).size.width),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                    color: CupertinoColors.systemBlue,
                    child: const Text("True"),
                    onPressed: () => BlocProvider.of<ValidationBloc>(context)
                        .add(ValidationInput(
                            key: state.key,
                            dataBytes: state.dataBytes,
                            keys: state.keys,
                            input: true))),
                const Spacer(),
                CupertinoButton(
                    color: CupertinoColors.systemBlue,
                    child: const Text("False"),
                    onPressed: () => BlocProvider.of<ValidationBloc>(context)
                        .add(ValidationInput(
                            key: state.key,
                            dataBytes: state.dataBytes,
                            keys: state.keys,
                            input: false))),
              ],
            ),
            const Spacer(),
            CupertinoButton(
              onPressed: () => BlocProvider.of<ValidationBloc>(context)
                  .add(ValidationPrev(currentKey: state.key, keys: state.keys)),
              child: const Text(
                "Previous Image",
                style: Styles.error,
              ),
            ),
          ]),
        )
      ],
    );
  }

  Widget onDispose(BuildContext context, ValidationDispose state) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
            child: Column(
          children: [
            const Text("No more data to validate", style: Styles.subactionText),
            CupertinoButton(
              onPressed: () => AppNav(context).back(),
              child: const Text("Go to home"),
            )
          ],
        )));
  }

  onError(BuildContext _, ValidationError state) {
    return Text(state.message, style: Styles.error);
  }

  Widget drawPose(List<Offset>? points) {
    return _ModelPainter(
      customPainter: PosePainter(
        points: points ?? [],
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
