import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  //
  final TextInputType inputType;
  final TextEditingController controller;
  final String errorText;
  final String hintText;
  final bool isEnabled;
  //
  MyTextField({
    this.inputType = TextInputType.text,
    this.isEnabled = true,
    required this.controller,
    required this.errorText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: isEnabled,
      keyboardType: inputType,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        return null;
      },
      cursorColor: Colors.redAccent,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        contentPadding: EdgeInsets.all(10.0),
      ),
    );
  }
}
