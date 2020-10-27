import 'package:flutter/material.dart';

class FormTextWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool autofocus;

  final TextInputType keyboardType;

  final String labelText;

  const FormTextWidget({
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.keyboardType,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        keyboardType: keyboardType,
        maxLines: keyboardType == TextInputType.multiline ? null : 1,
        decoration: decoration(labelText),
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  static InputDecoration decoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(fontSize: 16),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      ),
      border: UnderlineInputBorder(),
    );
  }
}
