import 'package:flutter/material.dart';

class GainerSecondaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final bool isAccepted;
  final bool isDisableColors;
  final bool isDisableTap;
  const GainerSecondaryButton({
    super.key,
    required this.onTap,
    required this.title,
    this.isAccepted = false,
    this.isDisableColors = false,
    this.isDisableTap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          isAccepted
              ? Colors.green
              : isDisableColors
                  ? Colors.white60
                  : null,
        ),
        padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 6, vertical: 4)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      onPressed: isDisableTap ? null : onTap,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 12, color: isAccepted ? Colors.white : Colors.black),
      ),
    );
  }
}
