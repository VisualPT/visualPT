import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/views/styles.dart';

import '../../bloc/bloc.dart';

class AuthInput extends StatefulWidget {
  final AuthDataType type;
  final bool obscure;
  const AuthInput(this.type, {this.obscure = false, super.key});

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
            placeholder: widget.type.name.toString(),
            placeholderStyle: Styles.placeholderStyle,
            style: Styles.inputStyle,
            textAlign: TextAlign.center,
            obscureText: obsController,
            onSubmitted: (value) => BlocProvider.of<AuthBloc>(context)
                .storeAuthData(widget.type, value),
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
              onTap: () => setState(() => obsController = !obsController),
            ),
          ),
      ],
    );
  }
}
