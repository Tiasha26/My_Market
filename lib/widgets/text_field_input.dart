import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  const TextFieldInput({super.key, required this.textInputType, required this.textEditingController, required this.hintText, this.isPass = false});

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: Divider.createBorderSide(context)
    );
    return  TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder ,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 8, horizontal: 15
        ),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
