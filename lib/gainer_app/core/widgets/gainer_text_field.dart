import 'package:flutter/material.dart';
import '../constants/gainer_color.dart';
class GainerTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPass;
  final String label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;

  const GainerTextField({
    super.key,
    required this.controller,
    this.isPass = false,
    required this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPass,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon,
        // prefixIcon: const Icon(Icons.lock),
        // suffixIcon: IconButton(
        //   icon: Icon(
        //     controller.isPasswordVisible.value
        //         ? Icons.visibility
        //         : Icons.visibility_off,
        //   ),
        //   onPressed: controller.togglePassword,
        // ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        fillColor: GainerColors.white,
        filled: true,
      ),
      validator: validator,
    );
  }
}
