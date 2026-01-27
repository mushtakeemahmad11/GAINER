import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/gainer_color.dart';

class GainerTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;

  const GainerTextFormField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.onTap,
    this.inputFormatters,
  });

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: 1.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        isDense: true,
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(fontSize: 14),
        hintStyle: TextStyle(fontSize: 14),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        border: _border(GainerColors.border),
        enabledBorder: _border(GainerColors.border),
        focusedBorder: _border(GainerColors.primary),
        errorBorder: _border(GainerColors.error),
        focusedErrorBorder: _border(GainerColors.error),
      ),
    );
  }
}

class GainerQtyField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool enable;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;

  const GainerQtyField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.keyboardType = TextInputType.number,
    this.readOnly = false,
    this.enable = true,
    this.validator,
    this.onChanged,
    this.onTap,
    this.inputFormatters,
  });

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: color, width: 1.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: TextFormField(
        style: TextStyle(
            color: enable ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold),
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        enabled: enable,
        validator: validator,
        onChanged: onChanged,
        onTap: onTap,
        textAlign: TextAlign.center,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(4),
          isDense: true,
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
              fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 12),
          filled: true,
          fillColor: enable ? Colors.white : Colors.black26,
          border: _border(GainerColors.border),
          enabledBorder: _border(GainerColors.border),
          focusedBorder: _border(GainerColors.primary),
          errorBorder: _border(GainerColors.error),
          focusedErrorBorder: _border(GainerColors.error),
        ),
      ),
    );
  }
}
