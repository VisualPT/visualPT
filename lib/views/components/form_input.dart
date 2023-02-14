import 'package:flutter/cupertino.dart';

class FormInput extends StatefulWidget {
  final String field;
  final TextEditingController controller;
  final TextInputType? inputType;
  Future<String?> Function()? inputPopup;
  FormInput(this.field, this.controller,
      {super.key, this.inputPopup, this.inputType})
      : assert(inputType != null || inputPopup != null);

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTextFormFieldRow(
      controller: widget.controller,
      textAlign: TextAlign.center,
      autocorrect: false,
      keyboardType: widget.inputType ?? TextInputType.none,
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border.all(),
        borderRadius: BorderRadius.circular(8.0),
      ),
      textCapitalization: TextCapitalization.words,
      placeholder: widget.field,
      validator: (value) => value == null || value.isEmpty
          ? 'Please enter a valid response'
          : null,
      //TODO Manage the controller.text (maybe do this after the rest of the UI build?)
      onTap: () => widget.inputPopup,
    );
  }
}
