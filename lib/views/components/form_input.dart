import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/views/_views.dart';

class FormInput extends StatefulWidget {
  final String field;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final Future<String?> Function()? inputPopup;
  final bool obscure;
  final AuthDataType? authType;
  const FormInput(this.field,
      {super.key,
      this.controller,
      this.inputPopup,
      this.inputType,
      this.obscure = false,
      this.authType})
      //There must exist a way of distinguishing what type of input board to present and how to display the data
      : assert(inputType != null || inputPopup != null || authType != null),
        //Either there is a text controller or an auth type specified for which a data controller function exists
        assert(controller != null || authType != null);

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  bool obsController = false;

  @override
  void initState() {
    super.initState();
    obsController = widget.obscure;
  }

  TextInputType keyboardTypeChooser(AuthDataType? authType) {
    switch (authType) {
      case AuthDataType.email:
        return TextInputType.emailAddress;
      case AuthDataType.password:
        return TextInputType.visiblePassword;
      case AuthDataType.confirmPassword:
        return TextInputType.visiblePassword;
      default:
        //Assume inputPopup is the supplied parameter
        return TextInputType.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    return
        //Stack(
        // alignment: Alignment.center,
        // children: [
        CupertinoTextFormFieldRow(
      controller: widget.controller,
      textAlign: TextAlign.center,
      autocorrect: false,
      keyboardType: widget.inputType ?? keyboardTypeChooser(widget.authType),
      textCapitalization: TextCapitalization.words,
      style: Styles.inputStyle,
      placeholder: widget.field,
      placeholderStyle: Styles.placeholderStyle,
      obscureText: widget.obscure,
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        border: Border.all(),
        borderRadius: BorderRadius.circular(8.0),
      ),
      validator: (value) => value == null || value.isEmpty
          ? 'Please enter a valid response'
          : null,
      onTap: () => widget.inputPopup != null
          ? widget.inputPopup!()
              .then((value) => widget.controller!.text = value ?? "")
          : null,
      onChanged: (value) => widget.authType != null
          ? BlocProvider.of<AuthBloc>(context)
              .storeAuthData(widget.authType!, value)
          //TODO Manage the controller.text (maybe do this after the rest of the UI build?)
          : null,
      //)
      //   Positioned(
      //     right: 24,
      //     child: GestureDetector(
      //       child: Icon(
      //           widget.obscure
      //               ? CupertinoIcons.eye_fill
      //               : CupertinoIcons.eye_slash_fill,
      //           color: CupertinoColors.inactiveGray),
      //       onTap: () => setState(() => obsController = !obsController),
      //     ),
      //   ),
      // ],
    );
  }
}
