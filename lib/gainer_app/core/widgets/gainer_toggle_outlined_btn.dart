import 'package:flutter/material.dart';

import '../constants/gainer_color.dart';

class GainerToggleOutlineBtn extends StatelessWidget {
  final String text;
  final bool isActive; // Boolean value to control the toggle state
  final VoidCallback onToggle; // Callback to pass the toggle state

  const GainerToggleOutlineBtn({
    super.key,
    required this.text,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: OutlinedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 15),
          ),
          backgroundColor: WidgetStateProperty.all(
            isActive ? GainerColors.primary : Colors.cyan[50],
          ),
        ),
        onPressed: onToggle,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? GainerColors.white : GainerColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
