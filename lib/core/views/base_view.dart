import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/views/components/_components.dart';
import 'package:visualpt/core/views/styles.dart';
import 'package:visualpt/features/assessment/view/components/assessment_instructions.dart';

class BaseView extends StatefulWidget {
  const BaseView(
      {super.key, required this.child, this.instructions, this.pageTitle});
  final Widget child;
  final AssessmentInstructions? instructions;
  final String? pageTitle;

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  bool showInstructions = true;

  @override
  void didUpdateWidget(BaseView oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() => showInstructions = true);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(alignment: Alignment.center, children: [
      CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: Styles.backgroundAccent,
            middle: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75),
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
                        onTap: () => setState(
                            () => showInstructions = !showInstructions),
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
              SafeArea(
                child: widget.child,
              )
            ]),
          )),
      //InstructionModal below
      showInstructions && widget.instructions != null
          ? Container(
              alignment: Alignment.center,
              height: screenSize.height,
              width: screenSize.width,
              color: Styles.black.withOpacity(0.5),
              child: GestureDetector(
                  child: Container(
                      height: screenSize.height * 0.7,
                      width: screenSize.width * 0.7,
                      //Create rounded corners
                      decoration: const BoxDecoration(
                          borderRadius: Styles.borderRadiusM,
                          color: Styles.ceruleanBlue),
                      child: widget.instructions),
                  onTap: () => setState(() => showInstructions = false)))
          : Container()
    ]);
  }
}
