import 'package:flutter/cupertino.dart';
import 'package:visualpt/views/styles.dart';

class AuthInput extends StatefulWidget {
  final String placeholder;
  final bool obscure;
  const AuthInput(this.placeholder, {this.obscure = false, super.key});

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  bool obsController = false;

  @override
  void initState() {
    super.initState();
    obsController = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: CupertinoTextField(
            placeholder: widget.placeholder,
            placeholderStyle: Styles.placeholderStyle,
            style: Styles.inputStyle,
            textAlign: TextAlign.center,
            obscureText: obsController,
          ),
        ),
        if (widget.obscure)
          Positioned(
            right: 24,
            child: GestureDetector(
                child: Icon(
                    obsController
                        ? CupertinoIcons.eye_fill
                        : CupertinoIcons.eye_slash_fill,
                    color: CupertinoColors.inactiveGray),
                onTap: () => setState(() => obsController = !obsController)),
          ),
      ],
    );
  }
}
