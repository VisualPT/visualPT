import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/views/components/_components.dart';
import 'package:visualpt/core/views/styles.dart';

class BaseView extends StatefulWidget {
  const BaseView(
      {super.key, required this.child, this.instructions, this.pageTitle});
  final Widget child;
  final Widget? instructions;
  final String? pageTitle;

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  bool showInstructions = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Styles.backgroundAccent,
          middle: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7),
              child: widget.pageTitle == null
                  ? const Image(
                      image: AssetImage(Styles.mainLogoPath),
                      fit: BoxFit.fitWidth)
                  : Text(
                      widget.pageTitle!,
                      style: Styles.heading3,
                      textAlign: TextAlign.center,
                    )),
          trailing: widget.pageTitle == null
              ? GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/settings"),
                  child: const Icon(
                    CupertinoIcons.settings,
                    color: Styles.black,
                  ))
              : widget.instructions != null
                  ? GestureDetector(
                      onTap: () =>
                          setState(() => showInstructions = !showInstructions),
                      child: const Icon(
                        CupertinoIcons.info,
                        color: Styles.black,
                      ))
                  : null,
        ),
        child: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: Stack(alignment: Alignment.center, children: [
            const ViewBackground(),
            SizedBox(
                height: screenSize.height,
                width: screenSize.width,
                child: Stack(alignment: Alignment.center, children: [
                  widget.child,
                  //InstructionModal below
                  showInstructions
                      ? GestureDetector(
                          child: Container(
                            color: CupertinoColors.black.withOpacity(0.5),
                            child: SizedBox(
                                height: screenSize.height * 0.7,
                                width: screenSize.width * 0.7,
                                child: widget.instructions),
                          ),
                          onTap: () => setState(() => showInstructions = false))
                      : Container()
                ])),
          ]),
        ));
  }
}
