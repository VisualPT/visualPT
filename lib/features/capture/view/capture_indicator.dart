import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/_core.dart';

class CaptureIndicator extends StatefulWidget {
  const CaptureIndicator(
      {super.key,
      required this.icon,
      required this.type,
      this.color = Styles.black,
      this.child =
          const Text("...", style: TextStyle(fontWeight: FontWeight.w300))});
  final IconData icon;
  final String type;
  final Color color;
  final Text child;

  @override
  State<CaptureIndicator> createState() => _CaptureIndicatorState();
}

class _CaptureIndicatorState extends State<CaptureIndicator> {
  bool showMessage = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
          onTapDown: (e) => setState(() => showMessage = true),
          onTapUp: (e) => setState(() => showMessage = false),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              Container(
                  height: 24,
                  width: 24,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color == Styles.black
                          ? Styles.white
                          : widget.color.withAlpha(128),
                      border: Border.all()),
                  child: Icon(widget.icon, size: 16, color: Styles.black)),
              Text("${widget.type} ", style: Styles.heading2),
              const Spacer(),
              widget.child,
            ]),
          )),
    );
  }
}
