import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hint;
  final TextInputType textInputType;
  final bool isPass;

  const TextInputField(
      {super.key,
      required this.textEditingController,
      required this.hint,
      required this.textInputType,
      this.isPass = false});

  @override
  Widget build(BuildContext context) {
    final borders =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hint,
        border: borders,
        enabledBorder: borders,
        focusedBorder: borders,
        filled: true,
        contentPadding: const EdgeInsets.all(9),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
