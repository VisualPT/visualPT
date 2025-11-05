import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/view/styles.dart';
import 'package:visualpt/features/assessment/view/components/assessment_instructions.dart';

class BaseView extends StatefulWidget {
  const BaseView(
      {super.key,
      required this.child,
      this.instructions,
      this.pageTitle,
      this.backgroundColor = Styles.white,
      this.poppable = true});
  final Widget child;
  final AssessmentInstructions? instructions;
  final String? pageTitle;
  final Color? backgroundColor;
  final bool poppable;

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  bool showInstructions = true;

  @override
  void initState() {
    super.initState();
    setState(
        () => showInstructions = widget.instructions == null ? false : true);
  }

  bool _canPop() {
    if (!widget.poppable || showInstructions) {
      return false;
    }
    return true; // Allow navigation otherwise
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return PopScope(
      canPop: _canPop(), // Override back button behavior
      child: Stack(alignment: Alignment.center, children: [
        CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              automaticallyImplyLeading: _canPop() ? true : false,
              backgroundColor: Styles.ceruleanBlue,
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
              trailing: widget.instructions != null
                  ? GestureDetector(
                      onTap: () =>
                          setState(() => showInstructions = !showInstructions),
                      child: const Icon(
                        CupertinoIcons.info,
                        color: Styles.black,
                      ))
                  : null,
            ),
            child: Container(
                height: screenSize.height,
                width: screenSize.width,
                color: widget.backgroundColor ?? Styles.white,
                child: SafeArea(
                  child: widget.child,
                ))),
        // InstructionModal below
        showInstructions && widget.instructions != null
            ? Container(
                alignment: Alignment.center,
                height: screenSize.height,
                width: screenSize.width,
                color: Styles.black.withValues(alpha: 0.5),
                child: GestureDetector(
                    child: Container(
                        height: screenSize.height * 0.9,
                        width: screenSize.width * 0.9,
                        decoration: const BoxDecoration(
                          borderRadius: Styles.borderRadiusM,
                          color: Styles.white,
                        ),
                        child: widget.instructions),
                    onTap: () => setState(() => showInstructions = false)))
            : Container()
      ]),
    );
  }
}
