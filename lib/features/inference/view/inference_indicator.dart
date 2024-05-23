import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/views/_views.dart';

class InferenceIndicator extends StatefulWidget {
  const InferenceIndicator(
      {super.key,
      required this.icon,
      required this.color,
      required this.type,
      required this.message,
      this.formattedTextWidget =
          const Text("...", style: TextStyle(fontWeight: FontWeight.w300))});
  final IconData icon;
  final Color color;
  final String type;
  final String message;
  final Text formattedTextWidget;

  @override
  State<InferenceIndicator> createState() => _InferenceIndicatorState();
}

class _InferenceIndicatorState extends State<InferenceIndicator> {
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
                      color: widget.color.withAlpha(128),
                      border: Border.all()),
                  child: Icon(widget.icon, size: 16, color: Styles.black)),
              Text("${widget.type} "),
              const Spacer(),
              widget.formattedTextWidget,
            ]),
          )),
    );
  }
}
