import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt_collector/features/inference/view/camera_painters/ctsib_overlays.dart';
import 'package:visualpt_collector/features/validation/bloc/validation_bloc.dart';
import 'package:visualpt_collector/features/validation/view/validation_presenter.dart';
import 'package:visualpt_collector/core/views/_views.dart';
import 'package:visualpt_collector/core/views/app_nav.dart';
import 'package:visualpt_collector/features/inference/view/camera_painters/pose_overlay.dart';
import 'package:visualpt_collector/core/views/components/_components.dart';
import 'package:visualpt_collector/models/ModelProvider.dart';

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
  final AssessmentType type;
  const ValidationView(this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      pageTitle: "Validate",
      child: Stack(
        children: [
          const ViewBackground(),
          ValidationPresenter(
            type,
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
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width),
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                  height: state.imageHeight.toDouble() * state.ratio,
                  width: state.imageWidth.toDouble() * state.ratio),
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  Image.memory(
                    Uint8List.fromList(state.imageBytes),
                    height: state.imageHeight.toDouble(),
                    width: state.imageWidth.toDouble(),
                    fit: BoxFit
                        .fitWidth, // This ensures that the image covers the entire space defined by height and width
                  ),
                  PoseSway(
                      points:
                          state.offsets.map((o) => o * state.ratio).toList()),
                  PoseOverlay(
                      points:
                          state.offsets.map((o) => o * state.ratio).toList()),
                ],
              )),
          Positioned(
            top: 0,
            child: Column(
              children: [
                Text("Remaining Images: ${(state.keys.length / 2).floor() + 1}",
                    style: Styles.subactionText),
                BlocProvider.of<ValidationBloc>(context)
                        .processedKeys
                        .isNotEmpty
                    ? CupertinoButton(
                        onPressed: () =>
                            BlocProvider.of<ValidationBloc>(context).add(
                                ValidationPrev(
                                    currentKey: state.key, keys: state.keys)),
                        child: const Text(
                          "Previous",
                          style: Styles.error,
                        ),
                      )
                    : Container(),
                Text("Collector: ${state.key.split("_").first}"),
                Text(
                    "Collection Date: ${DateTime.fromMillisecondsSinceEpoch(int.parse((state.key.split("_").last)))}")
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                CupertinoButton(
                    padding: const EdgeInsets.all(16),
                    color: CupertinoColors.systemGreen,
                    child: const Text("Static"),
                    onPressed: () => BlocProvider.of<ValidationBloc>(context)
                        .add(ValidationInput(
                            key: state.key,
                            dataBytes: state.dataBytes,
                            keys: state.keys,
                            classification: state.classification,
                            input: 0))),
                const Spacer(flex: 2),
                CupertinoButton(
                    padding: const EdgeInsets.all(16),
                    color: CupertinoColors.systemYellow,
                    child: const Text("Arm"),
                    onPressed: () => BlocProvider.of<ValidationBloc>(context)
                        .add(ValidationInput(
                            key: state.key,
                            dataBytes: state.dataBytes,
                            keys: state.keys,
                            classification: state.classification,
                            input: 1))),
                const Spacer(),
                CupertinoButton(
                    padding: const EdgeInsets.all(16),
                    color: CupertinoColors.systemYellow,
                    child: const Text("Trunk"),
                    onPressed: () => BlocProvider.of<ValidationBloc>(context)
                        .add(ValidationInput(
                            key: state.key,
                            dataBytes: state.dataBytes,
                            keys: state.keys,
                            classification: state.classification,
                            input: 2))),
                const Spacer(),
                CupertinoButton(
                    padding: const EdgeInsets.all(16),
                    color: CupertinoColors.systemYellow,
                    child: const Text("Foot"),
                    onPressed: () => BlocProvider.of<ValidationBloc>(context)
                        .add(ValidationInput(
                            key: state.key,
                            dataBytes: state.dataBytes,
                            keys: state.keys,
                            classification: state.classification,
                            input: 3))),
                const Spacer(flex: 2),
                CupertinoButton(
                    padding: const EdgeInsets.all(16),
                    color: CupertinoColors.systemRed,
                    child: const Text("Invalid"),
                    onPressed: () => BlocProvider.of<ValidationBloc>(context)
                        .add(ValidationInput(
                            key: state.key,
                            dataBytes: state.dataBytes,
                            keys: state.keys,
                            classification: state.classification,
                            input: -1))),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
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
}
