import 'package:flutter/material.dart';
import '../../main.dart';
import '../core/themes/scanapp_colors.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const CustomTextButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mq.width,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor:
              const WidgetStatePropertyAll(ScanappColors.secondary),
          // backgroundColor: WidgetStateProperty.all<Color>(
          //     Colors.teal[400]!), // Light teal color
          // overlayColor: WidgetStateProperty.all<Color>(
          //     Colors.teal.withOpacity(0.2)), // Ripple effect
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          padding: WidgetStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 12)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ScanappColors.white, // Dark text color
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
