import 'package:flutter/material.dart';
import '../screens/colors.dart';

class ToggleOutlineButton extends StatefulWidget {
  final String text;
  final bool isActive; // Boolean value to control the toggle state
  final VoidCallback onToggle; // Callback to pass the toggle state

  const ToggleOutlineButton({
    super.key,
    required this.text,
    required this.isActive,
    required this.onToggle,
  });

  @override
  State<ToggleOutlineButton> createState() => _ToggleOutlineButtonState();
}

class _ToggleOutlineButtonState extends State<ToggleOutlineButton> {
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
            widget.isActive ? AppColor.primary : Colors.cyan[50],
          ),
        ),
        onPressed: widget.onToggle,
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: widget.isActive ? AppColor.white : AppColor.primary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

