import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final bool isPass;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool isEmpty;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.text,
    this.isPass = false,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.isEmpty = false,
    this.validator,
    this.suffixIcon,
    this.inputFormatters,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mq.width,
      child: TextFormField(
        keyboardType: textInputType,
        controller: controller,
        obscureText: isPass,
        validator: validator,
        decoration: InputDecoration(
          // errorText: loginController.numberEmpty?"Value can't be empty":null,
          // hintText: text,
          labelText: text,
          // error: Text("data"),
          errorText: isEmpty ? 'Required field' : null,
          suffixIcon: suffixIcon,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
          // border: const OutlineInputBorder(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // rounded corners
            borderSide: const BorderSide(color: Colors.grey), // border color
          ),
        ),
        inputFormatters: inputFormatters,
      ),
    );
  }
}
