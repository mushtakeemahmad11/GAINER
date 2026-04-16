import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DmTextFormField extends StatelessWidget {
  const DmTextFormField({
    super.key,
    required this.controller,
    required this.text,
    this.isPass = false,
    this.textInputType = TextInputType.text,
    this.suffixIcon,
    this.isDisable = false,
    this.autoFocus = false,
    this.validator,
    this.length,
    this.onChanged,
    this.inputFormatters,
    // this.maxLine,
  });

  final TextEditingController controller;
  final String text;
  final bool isPass;
  final TextInputType textInputType;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final bool isDisable;
  final bool autoFocus;
  final int? length;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  // final int? maxLine;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      readOnly: isDisable,
      obscureText: isPass,
      maxLength: length,
      controller: controller,
      decoration: InputDecoration(
        counterText: '',
        label: Text(text),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      onChanged: onChanged,
      autofocus: autoFocus,
      inputFormatters: inputFormatters,
      // maxLines: maxLine,
    );
  }
}
